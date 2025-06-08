# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/products/index" do
  before { @pagy, @products = pagy_array(build_stubbed_list(:product, 2)) }

  it "renders a list of admin/products" do
    render
    name_selector = "tr>th"
    cell_selector = "tr>td"
    assert_select name_selector, text: Regexp.new("Product"), count: 2
    assert_select cell_selector, text: Regexp.new("100"), count: 2
  end
end
