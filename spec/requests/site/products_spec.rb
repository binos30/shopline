# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/products" do
  describe "GET /show" do
    it "renders a successful response (i.e. active product with stocks quantity > 0)" do
      category = Category.create!(name: "Category")
      product = category.products.create!(name: "Product")
      product.stocks.create!(size: "L", quantity: 3)
      get product_url(product)
      expect(response).to be_successful
    end
  end
end
