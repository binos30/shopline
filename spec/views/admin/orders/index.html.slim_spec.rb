# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/index" do
  let(:user) { build_stubbed(:user, first_name: "John", last_name: "Doe") }
  let(:order) { build_stubbed(:order, user:) }
  let(:order2) { build_stubbed(:order, user:) }

  before { @pagy, @orders = pagy_array([order, order2]) }

  it "renders a list of admin/orders" do
    render
    order_id_selector = "tr>th"
    cell_selector = "tr>td"
    assert_select order_id_selector, text: Regexp.new("SL"), count: 2
    assert_select cell_selector, text: Regexp.new("John Doe"), count: 2
  end
end
