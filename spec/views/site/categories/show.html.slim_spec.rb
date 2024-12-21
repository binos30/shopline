# frozen_string_literal: true

require "rails_helper"

RSpec.describe "site/categories/show", type: :view do
  let!(:category) { create :category }

  before do
    assign(:category, category)
    @pagy, @products = pagy(category.products)
  end

  it "renders attribute" do
    render
    expect(rendered).to match(/Category/)
  end
end
