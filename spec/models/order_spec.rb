# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order do
  let!(:user) do
    User.create!(
      role: Role.find_or_create_by!(name: "Administrator"),
      gender: "male",
      email: "jd@gmail.com",
      password: "pass1234",
      first_name: "John",
      last_name: "Doe"
    )
  end
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) { Product.create!(name: "Product", category:) }
  let!(:stock) { product.stocks.create!(size: "L", quantity: 3) }

  it "does not save without item" do
    order =
      described_class.new(
        user:,
        customer_email: user.email,
        customer_full_name: user.full_name,
        customer_address: "my address 1"
      )
    expect(order.save).to be false
  end

  it "saves" do # rubocop:disable RSpec/ExampleLength
    order =
      described_class.new(
        user:,
        customer_email: user.email,
        customer_full_name: user.full_name,
        customer_address: "my address 1"
      )
    order.order_items.build(
      product:,
      stock:,
      order_code: order.order_code,
      product_name: product.name,
      product_price: product.price,
      size: stock.size,
      quantity: 2
    )
    expect(order.save).to be true
  end
end
