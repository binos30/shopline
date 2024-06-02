# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/index" do
  let!(:category) { Category.create!(name: "Category") }

  before do
    assign(
      :products,
      [
        Product.create!(name: "Product", description: "MyText", price: "9.99", category:),
        Product.create!(name: "Name", description: "MyText", price: "9.99", category:)
      ]
    )
  end

  it "renders a list of admin/products" do
    render
    name_selector = "tr>th"
    cell_selector = "tr>td"
    assert_select name_selector, text: Regexp.new("Product".to_s), count: 1
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
  end
end
