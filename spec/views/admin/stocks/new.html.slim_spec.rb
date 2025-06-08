# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/stocks/new" do
  let(:product) { build_stubbed(:product) }

  before do
    assign(:product, product)
    assign(:stock, build(:stock, product:))
  end

  it "renders new stock form" do
    render

    assert_select "form[action=?][method=?]", admin_product_stocks_path(product), "post" do
      assert_select "input[name=?]", "stock[size]"

      assert_select "input[name=?]", "stock[quantity]"
    end
  end
end
