# frozen_string_literal: true

module Site
  class CheckoutController < SiteController
    before_action :check_and_authenticate_user

    def create # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      cart = params[:cart]
      items =
        cart.map do |item|
          product = Product.includes(:stocks).active.find(item["id"])
          product_stock = product.stocks.find { |s| s.size == item["size"] }

          if product_stock.quantity < item["quantity"].to_i
            error =
              "Not enough stock for #{product.name} in size #{item["size"]}. Only #{product_stock.quantity} left."
            return render json: { error: }, status: :bad_request
          end

          {
            quantity: item["quantity"].to_i,
            price_data: {
              product_data: {
                name: item["name"],
                metadata: {
                  customer_id: current_user.id,
                  product_id: product.id,
                  size: item["size"],
                  product_stock_id: product_stock.id
                }
              },
              currency: "usd",
              unit_amount: item["price"].to_i
            }
          }
        end
      session =
        Stripe::Checkout::Session.create(
          mode: "payment",
          line_items: items,
          success_url: "http://localhost:3000/success",
          cancel_url: "http://localhost:3000/cancel",
          shipping_address_collection: {
            allowed_countries: %w[CA PH US]
          }
        )
      render json: { url: session.url }
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      render json: { error: e }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e }, status: :internal_server_error
    end

    def success
      render :success
    end

    def cancel
      render :cancel
    end

    private

    def check_and_authenticate_user
      return if user_signed_in?
      render json: { login_path: new_user_session_path }, status: :unauthorized
    end
  end
end
