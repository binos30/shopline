# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/admin/customers" do
  let!(:admin) { create(:user, :as_admin) }

  before { sign_in(admin) }

  describe "GET /index" do
    it "returns http success" do
      get admin_customers_url
      expect(response).to have_http_status(:success)
    end
  end
end
