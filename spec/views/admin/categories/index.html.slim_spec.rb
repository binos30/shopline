# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/categories/index" do
  before { @pagy, @categories = pagy_array(build_stubbed_list(:category, 2)) }

  it "renders a list of admin/categories" do
    render
    name_selector = "tr>th"
    description_selector = "tr>td"
    assert_select name_selector, text: Regexp.new("Category"), count: 2
    assert_select description_selector, text: Regexp.new("Description"), count: 2
  end
end
