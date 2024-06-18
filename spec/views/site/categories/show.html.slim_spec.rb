# frozen_string_literal: true

require "rails_helper"

RSpec.describe "site/categories/show" do
  let!(:category) { Category.create!(name: "Name2", description: "MyText") }

  before do
    assign(:category, category)
    assign(:products, category.products)
  end

  it "renders attribute" do
    render
    expect(rendered).to match(/Name2/)
  end
end
