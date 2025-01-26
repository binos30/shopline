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
      OrderCreator.call!(session)
    when "customer.created"
      customer = event.data.object
      user = User.find_by(email: customer.email)
      user&.update!(stripe_customer_id: customer.id)
    when "customer.deleted"
      customer = event.data.object
      user = User.find_by(stripe_customer_id: customer.id)
      user&.update!(stripe_customer_id: nil)
    else
      message = "Unhandled event type: #{event.type}"
      logger.tagged("Stripe Checkout Webhook") { logger.error message }
      return render json: { message: }
    end

    logger.tagged("Stripe Checkout Webhook") { logger.info "Checkout Success!" }
    render json: { message: "success" }
  rescue StandardError => e
    logger.tagged("Stripe Checkout Webhook Error") { logger.error e }
    head :bad_request
  end
end
