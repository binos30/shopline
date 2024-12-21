# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/index", type: :view do
  let!(:user) { create :user, first_name: "John", last_name: "Doe" }
  let!(:order) { create :order, user: }
  let(:order2) { create :order, user: }

  before { @pagy, @orders = pagy_array([order, order2]) }

  it "renders a list of admin/orders" do
    render
    order_id_selector = "tr>th"
    cell_selector = "tr>td"
    assert_select order_id_selector, text: Regexp.new("SL"), count: 2
    assert_select cell_selector, text: Regexp.new("John Doe"), count: 2
  end
end
