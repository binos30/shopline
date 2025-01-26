# frozen_string_literal: true

class OrderCreator < ApplicationService
  def initialize(session)
    @session = session
  end

  def call!
    shipping_details = @session["shipping_details"]
    address =
      "#{shipping_details["address"]["line1"]} #{shipping_details["address"]["city"]}, #{shipping_details["address"]["state"]} #{shipping_details["address"]["postal_code"]}" # rubocop:disable Layout/LineLength
    full_session = Stripe::Checkout::Session.retrieve(id: @session["id"], expand: ["line_items"])
    line_items = full_session.line_items

    Order.transaction do
      order =
        Order.new(
          user_id: @session["metadata"]["user_id"],
          customer_full_name: @session["metadata"]["user_full_name"],
          customer_email: @session["customer_details"]["email"],
          customer_address: address,
          total: @session["amount_total"].to_f / 100
        )
      order.build_order_items(line_items)
      order.save!
    end
  end
end
