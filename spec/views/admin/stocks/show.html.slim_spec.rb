# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/show" do
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) { Product.create!(name: "Name", description: "MyText", price: "9.99", category:) }
  let!(:stock) { Stock.create!(product:, size: "Size", quantity: 2) }

  before do
    assign(:product, product)
    assign(:stock, stock)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Size/)
    expect(rendered).to match(/2/)
  end
end
