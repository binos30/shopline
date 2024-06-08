# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/categories" do
  describe "GET /show" do
    it "renders a successful response" do
      category = Category.create!(name: "Category")
      get category_url(category)
      expect(response).to be_successful
    end
  end
end
