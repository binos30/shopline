# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/admin/subscribers", type: :request do
  let!(:admin) { create :user, :as_admin }

  before { sign_in(admin) }

  describe "GET /index" do
    before do
      build_stubbed_list(:subscriber, 2)
      get admin_subscribers_url
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end
end
