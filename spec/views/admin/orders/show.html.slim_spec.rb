# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/show" do
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
  let!(:product) { Product.create!(name: "Product", category:, price: 9.99) }
  let!(:stock) { product.stocks.create!(size: "L", quantity: 4) }
  let!(:order) do
    order =
      Order.new(
        user:,
        customer_email: user.email,
        customer_full_name: user.full_name,
        customer_address: "Customer Address"
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

  before { assign(:order, order) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/jd@gmail.com/)
    expect(rendered).to match(/John Doe/)
    expect(rendered).to match(/Customer Address/)
  end
end
