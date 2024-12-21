# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/show", type: :view do
  let!(:product) { create :product, :with_stocks, stocks_count: 1 }
  let(:stock) { product.stocks.first }

  before do
    assign(:product, product)
    assign(:stock, stock)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/SZ/)
    expect(rendered).to match(/50/)
  end
end
