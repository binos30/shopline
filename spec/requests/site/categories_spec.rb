# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/categories" do
  describe "GET /show" do
    let!(:category) { create(:category) }

    before { get category_url(category) }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end
end
