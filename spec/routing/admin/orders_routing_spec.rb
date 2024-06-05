# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::OrdersController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/orders").to route_to("admin/orders#index")
    end

    it "routes to #show" do
      expect(get: "/admin/orders/1").to route_to("admin/orders#show", id: "1")
    end
  end
end
