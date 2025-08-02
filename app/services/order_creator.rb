# frozen_string_literal: true

class OrderCreator < ApplicationService
  MAX_RETRIES = 3
  RETRY_DELAY = 2.seconds

  def initialize(session)
    @session = session
  end

  def call!
    retries = 0

    begin
      create_order
    rescue StandardError => e
      retries += 1
      if retries <= MAX_RETRIES
        Rails.logger.warn "Order creation failed. Retrying in #{RETRY_DELAY} seconds... (Attempt #{retries}/#{MAX_RETRIES})"
        sleep RETRY_DELAY
        retry # This is a Ruby keyword that retries the `begin` block
      else
        Rails.logger.error "Order creation failed after #{MAX_RETRIES} attempts. Raising error."
        raise e # Re-raise the error if all retries fail
      end
    end
  end

  private

  def create_order
    # Cache variables that shouldn't be recalculated on retry
    @shipping_details ||= @session["shipping_details"]
    @address ||=
      begin
        addr = @shipping_details["address"]
        "#{addr["line1"]} #{addr["city"]}, #{addr["state"]} #{addr["postal_code"]}"
      end
    @full_session ||= Stripe::Checkout::Session.retrieve(id: @session["id"], expand: ["line_items"])
    @line_items ||= @full_session.line_items

    # Start a transaction to ensure atomicity
    Order.transaction do
      order =
        Order.new(
          user_id: @session["metadata"]["user_id"],
          customer_full_name: @session["metadata"]["user_full_name"],
          customer_email: @session["customer_details"]["email"],
          customer_address: @address,
          total: @session["amount_total"].to_f / 100
        )
      order.build_order_items(@line_items)
      order.save!
    end
  end
end
