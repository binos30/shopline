# frozen_string_literal: true

class WebhookHandler < ApplicationService
  def initialize(event)
    @event = event
  end

  def call!
    case @event.type
    when "checkout.session.completed"
      handle_checkout_session_completed
    when "customer.created"
      handle_customer_created
    when "customer.deleted"
      handle_customer_deleted
    else
      message = "Unhandled event type: #{@event.type}"
      Rails.logger.tagged("Stripe Webhook", @event.type) { Rails.logger.error message }
      return { message: }
    end

    { message: "success" }
  end

  private

  def handle_checkout_session_completed
    session = @event.data.object
    OrderCreator.call!(session)
  end

  def handle_customer_created
    customer = @event.data.object
    user = User.find_by(email: customer.email)
    user&.update!(stripe_customer_id: customer.id)
  end

  def handle_customer_deleted
    customer = @event.data.object
    user = User.find_by(stripe_customer_id: customer.id)
    user&.update!(stripe_customer_id: nil)
  end
end
