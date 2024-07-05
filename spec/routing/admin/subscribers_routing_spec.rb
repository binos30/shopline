# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::SubscribersController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/subscribers").to route_to("admin/subscribers#index")
    end
  end
end
