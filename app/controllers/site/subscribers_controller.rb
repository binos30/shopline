# frozen_string_literal: true

module Site
  class SubscribersController < SiteController
    before_action :check_and_authenticate_user, except: :new

    def new
      @subscriber = Subscriber.new
    end

    def create
      Subscriber.transaction do
        @subscriber = Subscriber.new(subscriber_params)
        @subscriber.save!
      end
    rescue StandardError => e
      logger.tagged("Create Subscriber Error") { logger.error e }
      render :new, status: :unprocessable_entity
    end

    private

    # Only allow a list of trusted parameters through.
    def subscriber_params
      params.require(:subscriber).permit(:email).each_value { |value| value.try(:strip!) }
    end

    def check_and_authenticate_user
      turbo_stream_redirect(new_user_session_url) and return unless user_signed_in?
      return if user_signed_in? && current_user.customer?
      turbo_stream_redirect(
        root_url,
        flash_type: :warning,
        flash_message: "You must be a customer to be able to subscribe."
      ) and return
    end
  end
end
