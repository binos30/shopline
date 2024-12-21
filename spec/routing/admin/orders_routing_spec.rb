# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::OrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/orders").to route_to("admin/orders#index")
    end

    it "routes to #show" do
      expect(get: "/admin/orders/SL-1718256776-05").to route_to(
        "admin/orders#show",
        order_code: "SL-1718256776-05"
      )
    end
  end
end
