# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/edit" do
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) do
    Product.create!(name: "MyString", description: "MyText", price: "9.99", category:)
  end
  let(:stock) { Stock.create!(product:, size: "MyString", quantity: 1) }

  before do
    assign(:product, product)
    assign(:stock, stock)
  end

  it "renders the edit stock form" do
    render

    assert_select "form[action=?][method=?]", admin_product_stock_path(product, stock), "post" do
      assert_select "input[name=?]", "stock[size]"

      assert_select "input[name=?]", "stock[quantity]"
    end
  end
end
