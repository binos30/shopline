# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/new" do
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) do
    Product.create!(name: "MyString", description: "MyText", price: "9.99", category:)
  end

  before do
    assign(:product, product)
    assign(:stock, Stock.new(product:, size: "MyString", quantity: 1))
  end

  it "renders new stock form" do
    render

    assert_select "form[action=?][method=?]", admin_product_stocks_path(product), "post" do
      assert_select "input[name=?]", "stock[size]"

      assert_select "input[name=?]", "stock[quantity]"
    end
  end
end
