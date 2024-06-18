# frozen_string_literal: true

require "rails_helper"

RSpec.describe "site/products/show" do
  let!(:category) { Category.create!(name: "Name3", description: "MyText") }
  let!(:product) { Product.create!(name: "Name", description: "MyText", category:) }

  before { assign(:product, product) }

  it "renders attribute" do
    render
    expect(rendered).to match(/Name/)
  end
end
