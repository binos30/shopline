# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/index" do
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
  let!(:product) { Product.create!(name: "MyProduct", category:, price: 9.99) }
  let!(:stock) { product.stocks.create!(size: "L", quantity: 4) }
  let!(:order) do
    order =
      Order.new(
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
    order.save!
    order
  end

  before { @pagy, @orders = pagy_array([order, order]) }

  it "renders a list of admin/orders" do
    render
    order_id_selector = "tr>th"
    cell_selector = "tr>td"
    assert_select order_id_selector, text: Regexp.new("SL".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("John Doe".to_s), count: 2
  end
end
