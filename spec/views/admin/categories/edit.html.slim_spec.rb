# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/categories/edit" do
  let(:category) { Category.create!(name: "MyString", description: "MyText") }

  before { assign(:category, category) }

  it "renders the edit admin_category form" do
    render

    assert_select "form[action=?][method=?]", admin_category_path(category), "post" do
      assert_select "input[name=?]", "category[name]"

      assert_select "input[name=?]", "category[description]"
    end
  end
end
