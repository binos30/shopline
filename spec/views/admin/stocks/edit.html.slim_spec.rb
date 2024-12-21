# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/edit", type: :view do
  let!(:product) { create :product, :with_stocks, stocks_count: 1 }
  let(:stock) { product.stocks.first }

  before do
    assign(:product, product)
    assign(:stock, stock)
  end

  it "renders the edit stock form" do
    render

    assert_select "form[action=?][method=?]", admin_product_stock_path(product, stock), "post" do
      assert_select "input[name=?]", "stock[size]"

      assert_select "input[name=?]", "stock[quantity]"
    end
  end
end
