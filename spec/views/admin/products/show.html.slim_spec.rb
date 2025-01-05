# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/show", type: :view do
  let(:product) { build_stubbed :product }

  before { assign(:product, product) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Product/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/100/)
  end
end
