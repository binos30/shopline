# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/admin/customers" do
  let!(:user) do
    User.create!(
      role: Role.find_or_create_by!(name: "Administrator"),
      gender: "male",
      email: "jd@gmail.com",
      password: "pass123",
      first_name: "John",
      last_name: "Doe"
    )
  end

  before { sign_in(user) }

  describe "GET /index" do
    it "returns http success" do
      get admin_customers_url
      expect(response).to have_http_status(:success)
    end
  end
end
