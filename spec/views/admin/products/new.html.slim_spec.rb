# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/new" do
  let!(:categories) { Category.active }

  before do
    assign(:categories, categories)
    assign(:product, Product.new(name: "MyString", description: "MyText", price: "9.99"))
  end

  it "renders new product form" do
    render

    assert_select "form[action=?][method=?]", admin_products_path, "post" do
      assert_select "select[name=?]", "product[category_id]"

      assert_select "input[name=?]", "product[name]"

      assert_select "input[name=?]", "product[description]"

      assert_select "input[name=?]", "product[price]"

      assert_select "input[name=?]", "product[active]"
    end
  end
end
