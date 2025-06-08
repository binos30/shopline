# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/products" do
  describe "GET /show" do
    let!(:product) { create(:product, :with_stocks) }

    before { get product_url(product) }

    it "renders a successful response (i.e. active product with stocks quantity > 0)" do
      expect(response).to be_successful
    end
  end
end
