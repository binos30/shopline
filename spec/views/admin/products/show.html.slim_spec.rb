# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/show" do
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) { Product.create!(name: "Name", description: "MyText", price: "9.99", category:) }

  before { assign(:product, product) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/9.99/)
  end
end
