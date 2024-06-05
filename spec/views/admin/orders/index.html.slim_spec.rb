# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/index" do
  let!(:user) do
    User.create!(
      role: Role.find_or_create_by!(name: "Administrator"),
      email: "jd@gmail.com",
      password: "pass1234",
      first_name: "John",
      last_name: "Doe"
    )
  end
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) { Product.create!(name: "MyProduct", category:, price: 9.99) }
  let!(:stock) { product.stocks.create!(size: "L", quantity: 4) }

  before do
    assign(
      :orders,
      [
        Order.create!(
          product:,
          user:,
          product_name: product.name,
          product_price: product.price,
          size: stock.size,
          quantity: 2,
          customer_email: user.email,
          customer_full_name: user.full_name,
          customer_address: "Customer Address"
        ),
        Order.create!(
          product:,
          user:,
          product_name: product.name,
          product_price: product.price,
          size: stock.size,
          quantity: 2,
          customer_email: user.email,
          customer_full_name: user.full_name,
          customer_address: "Customer Address"
        )
      ]
    )
  end

  it "renders a list of admin/orders" do
    render
    product_selector = "tr>th"
    cell_selector = "tr>td"
    assert_select product_selector, text: Regexp.new("MyProduct".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("L".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("John Doe".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Customer Address".to_s), count: 2
  end
end
