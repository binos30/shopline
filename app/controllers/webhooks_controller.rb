# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = STRIPE_WEBHOOK_SECRET

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      logger.tagged("Stripe Webhook Error", "Invalid payload") { logger.error e }
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      logger.tagged("Stripe Webhook Error", "Invalid signature") { logger.error e }
      head :bad_request
      return
    end

    result = WebhookHandler.call!(event)

    render json: { message: result[:message] }
  rescue StandardError => e
    logger.tagged("Stripe Webhook Error") { logger.error e }
    head :bad_request
  end
end
