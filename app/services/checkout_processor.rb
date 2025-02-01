# frozen_string_literal: true

class CheckoutProcessor < ApplicationService
  def initialize(cart, user, view_context)
    @cart = cart
    @user = user
    @view_context = view_context
  end

  def call
    items = build_items
    return items if items.is_a?(Hash) && items[:error]

    session = create_stripe_session(items)
    { url: session.url }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    Rails.logger.tagged("Checkout Error") { Rails.logger.error e }
    { error: e.message, status: :unprocessable_entity }
  end

  private

  def build_items
    @cart.map do |item|
      product = Product.includes([:stocks, { images_attachments: :blob }]).active.find(item["id"])
      product_stock = product.stocks.find { |s| s.size == item["size"] }

      if product_stock.quantity < item["quantity"].to_i
        error =
          "Not enough stock for #{product.name} in size #{item["size"]}. Only #{product_stock.quantity} left."
        return { error:, status: :bad_request }
      end

      {
        quantity: item["quantity"].to_i,
        price_data: {
          product_data: {
            name: item["name"],
            images: product.images.map { |img| @view_context.rails_blob_url(img) },
            metadata: {
              product_id: product.id,
              size: item["size"],
              product_stock_id: product_stock.id
            }
          },
          currency: "usd",
          unit_amount_decimal: item["price"].to_f * 100
        }
      }
    end
  end

  def create_stripe_session(items)
    Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: items,
      customer: @user.stripe_customer_id,
      customer_creation: @user.stripe_customer_id ? nil : "always",
      customer_email: @user.stripe_customer_id ? nil : @user.email,
      metadata: {
        user_id: @user.id,
        user_full_name: @user.full_name
      },
      success_url: "#{@view_context.order_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: @view_context.order_cancel_url,
      shipping_address_collection: {
        allowed_countries: %w[CA PH US]
      }
    )
  end
end
