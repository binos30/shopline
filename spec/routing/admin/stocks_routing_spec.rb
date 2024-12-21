# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::StocksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/products/1/stocks").to route_to("admin/stocks#index", product_slug: "1")
    end

    it "routes to #new" do
      expect(get: "/admin/products/1/stocks/new").to route_to("admin/stocks#new", product_slug: "1")
    end

    it "routes to #show" do
      expect(get: "/admin/products/1/stocks/1").to route_to("admin/stocks#show", product_slug: "1", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/products/1/stocks/1/edit").to route_to("admin/stocks#edit", product_slug: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/admin/products/1/stocks").to route_to("admin/stocks#create", product_slug: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/products/1/stocks/1").to route_to("admin/stocks#update", product_slug: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/products/1/stocks/1").to route_to("admin/stocks#update", product_slug: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/products/1/stocks/1").to route_to("admin/stocks#destroy", product_slug: "1", id: "1")
    end
  end
end
