# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/show" do
  let(:product) { build_stubbed(:product) }

  before { assign(:product, product) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to include("Product")
    expect(rendered).to include("Description")
    expect(rendered).to include("100")
  end
end
