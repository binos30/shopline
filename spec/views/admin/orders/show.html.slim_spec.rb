# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/show" do
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
  let!(:product) { Product.create!(name: "Product", category:, price: 9.99) }
  let!(:stock) { product.stocks.create!(size: "L", quantity: 4) }

  before do
    assign(
      :order,
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
    )
  end

  it "renders attributes in <p>" do # rubocop:disable RSpec/MultipleExpectations
    render
    expect(rendered).to match(/Product/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/L/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/jd@gmail.com/)
    expect(rendered).to match(/John Doe/)
    expect(rendered).to match(/Customer Address/)
  end
end
