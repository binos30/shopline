# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/categories/new" do
  before { assign(:category, build(:category)) }

  it "renders new admin_category form" do
    render

    assert_select "form[action=?][method=?]", admin_categories_path, "post" do
      assert_select "input[name=?]", "category[name]"

      assert_select "input[name=?]", "category[description]"
    end
  end
end
