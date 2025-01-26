# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = STRIPE_WEBHOOK_SECRET

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      logger.tagged("Stripe Checkout Webhook Error", "Invalid payload") { logger.error e }
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      logger.tagged("Stripe Checkout Webhook Error", "Invalid signature") { logger.error e }
      head :bad_request
      return
    end

    case event.type
    when "checkout.session.completed"
      session = event.data.object
      shipping_details = session["shipping_details"]
      address =
        "#{shipping_details["address"]["line1"]} #{shipping_details["address"]["city"]}, #{shipping_details["address"]["state"]} #{shipping_details["address"]["postal_code"]}" # rubocop:disable Layout/LineLength
      full_session = Stripe::Checkout::Session.retrieve(id: session["id"], expand: ["line_items"])
      line_items = full_session.line_items

      Order.transaction do
        order =
          Order.new(
            user_id: session["metadata"]["user_id"],
            customer_full_name: session["metadata"]["user_full_name"],
            customer_email: session["customer_details"]["email"],
            customer_address: address,
            total: session["amount_total"].to_f / 100
          )
        line_items["data"].each do |item|
          product = Stripe::Product.retrieve(item["price"]["product"])
          product_id = product["metadata"]["product_id"].to_i
          stock = Stock.find(product["metadata"]["product_stock_id"])
          order.order_items.build(
            product_id:,
            stock:,
            product_name: product["name"],
            product_price: item["price"]["unit_amount_decimal"].to_f / 100,
            size: product["metadata"]["size"],
            quantity: item["quantity"]
          )
          stock.update!(quantity: stock.quantity - item["quantity"].to_i)
        end
        order.save!
      end
    when "customer.created"
      customer = event.data.object
      user = User.find_by(email: customer.email)
      user&.update!(stripe_customer_id: customer.id)
    when "customer.deleted"
      customer = event.data.object
      user = User.find_by(stripe_customer_id: customer.id)
      user&.update!(stripe_customer_id: nil)
    else
      logger.tagged("Stripe Checkout Webhook") { logger.error "Unhandled event type: #{event.type}" }
    end

    logger.tagged("Stripe Checkout Webhook") { logger.info "Checkout Success!" }
    render json: { message: "success" }
  rescue StandardError => e
    logger.tagged("Stripe Checkout Webhook Error") { logger.error e }
    head :bad_request
  end
end
