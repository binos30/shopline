# frozen_string_literal: true

require "rails_helper"

RSpec.describe "site/products/show", type: :view do
  let!(:product) { create :product }

  before do
    assign(:product, product)
    assign(:product_data, product.as_json(only: %i[id name price slug]))
  end

  it "renders attribute" do
    render
    expect(rendered).to match(/Product/)
  end
end
