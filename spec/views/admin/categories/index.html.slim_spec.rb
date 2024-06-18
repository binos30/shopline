# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/categories/index" do
  before do
    @pagy, @categories =
      pagy_array(
        [
          Category.create!(name: "MyCategory1", description: "MyText"),
          Category.create!(name: "MyCategoryName", description: "MyText")
        ]
      )
  end

  it "renders a list of admin/categories" do
    render
    name_selector = "tr>th"
    description_selector = "tr>td"
    assert_select name_selector, text: Regexp.new("MyCategory1".to_s), count: 1
    assert_select description_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
