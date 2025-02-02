# frozen_string_literal: true

module Site
  class CheckoutController < SiteController
    before_action :check_and_authenticate_user

    def create
      result = CheckoutProcessor.call(checkout_params[:cart], current_user, view_context)

      if result[:error]
        render json: { error: result[:error] }, status: result[:status]
      else
        render json: { url: result[:url] }
      end
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
      redirect_to root_url, alert: e
    end

    def cancel
      render :cancel
    end

    private

    def check_and_authenticate_user
      return render json: { login_path: new_user_session_path }, status: :unauthorized unless user_signed_in?

      if !current_user.customer?
        render json: {
                 error: "You're not authorized to checkout because you're not a customer"
               },
               status: :unauthorized and return
      end
    end

    def checkout_params
      params.require(:checkout).permit(cart: %i[id name size price quantity])
    end
  end
end
