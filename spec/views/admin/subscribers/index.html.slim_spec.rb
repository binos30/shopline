# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/subscribers/index" do
  let(:subscriber_john) { build_stubbed(:subscriber, email: "jd@gmail.com") }
  let(:subscriber_jane) { build_stubbed(:subscriber, email: "jd@email.com") }

  before { @pagy, @subscribers = pagy_array([subscriber_john, subscriber_jane]) }

  it "renders a list of admin/subscribers" do
    render
    cell_selector = "tr>td"
    assert_select cell_selector, text: Regexp.new("jd"), count: 2
  end
end
