# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/index" do
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) { Product.create!(name: "MyString", description: "MyText", price: "9.99", category:) }

  before do
    assign(:product, product)
    assign(
      :stocks,
      [Stock.create!(product:, size: "M", quantity: 2), Stock.create!(product:, size: "L", quantity: 2)]
    )
  end

  it "renders a list of admin/stocks" do
    render
    size_selector = "tr>th"
    quantity_selector = "tr>td"
    assert_select size_selector, text: Regexp.new("M".to_s), count: 1
    assert_select quantity_selector, text: Regexp.new(2.to_s), count: 2
  end
end
