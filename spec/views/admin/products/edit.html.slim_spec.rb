# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/edit" do
  let!(:categories) { Category.active }
  let(:product) { build_stubbed(:product) }

  before do
    assign(:categories, categories)
    assign(:product, product)
  end

  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", admin_product_path(product), "post" do
      assert_select "select[name=?]", "product[category_id]"

      assert_select "input[name=?]", "product[name]"

      assert_select "input[name=?]", "product[description]"

      assert_select "input[name=?]", "product[price]"

      assert_select "input[name=?]", "product[active]"
    end
  end
end
