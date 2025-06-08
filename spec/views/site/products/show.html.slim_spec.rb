# frozen_string_literal: true

require "rails_helper"

RSpec.describe "site/products/show" do
  let(:product) { build_stubbed(:product) }

  before do
    assign(:product, product)
    assign(:product_data, product.as_json(only: %i[id name price slug]))
  end

  it "renders attribute" do
    render
    expect(rendered).to match(/Product/)
  end
end
