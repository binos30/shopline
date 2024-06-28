# frozen_string_literal: true

module Site
  class CheckoutController < SiteController
    before_action :check_and_authenticate_user

    def create # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      cart = params[:cart]
      items =
        cart.map do |item|
          product =
            Product.includes([:stocks, { images_attachments: :blob }]).active.find(item["id"])
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
                description: product.description.presence || nil,
                images: product.images.map { |img| url_for(img) },
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
      session =
        Stripe::Checkout::Session.create(
          mode: "payment",
          line_items: items,
          customer: current_user.stripe_customer_id,
          customer_creation: current_user.stripe_customer_id ? nil : "always",
          customer_email: current_user.stripe_customer_id ? nil : current_user.email,
          metadata: {
            user_id: current_user.id,
            user_full_name: current_user.full_name
          },
          success_url: "#{order_success_url}?session_id={CHECKOUT_SESSION_ID}",
          cancel_url: order_cancel_url,
          shipping_address_collection: {
            allowed_countries: %w[CA PH US]
          }
        )
      render json: { url: session.url }
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      logger.tagged("Checkout Error") { logger.error e }
      render json: { error: e }, status: :unprocessable_entity
    rescue StandardError => e
      logger.tagged("Checkout Error") { logger.error e }
      render json: { error: e }, status: :internal_server_error
    end

    def success
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @customer = Stripe::Customer.retrieve(session.customer)

      render :success
    rescue Stripe::InvalidRequestError => e
      logger.tagged("Stripe::InvalidRequestError") { logger.error e }
      redirect_to root_url
    end

    def cancel
      render :cancel
    end

    private

    def check_and_authenticate_user
      if user_signed_in? && !current_user.customer?
        return(
          render(
            json: {
              error: "You're not authorized to checkout because you're not a customer"
            },
            status: :unauthorized
          )
        )
      end
      return if user_signed_in?
      render json: { login_path: new_user_session_path }, status: :unauthorized
    end
  end
end
