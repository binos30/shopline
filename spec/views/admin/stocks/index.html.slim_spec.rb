# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/index" do
  let!(:product) { create(:product, :with_stocks) }

  before do
    assign(:product, product)
    assign(:stocks, product.stocks)
  end

  it "renders a list of admin/stocks" do
    render
    size_selector = "tr>th"
    quantity_selector = "tr>td"
    assert_select size_selector, text: Regexp.new("SZ"), count: 2
    assert_select quantity_selector, text: Regexp.new("50"), count: 2
  end
end
