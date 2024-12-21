# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/orders/show", type: :view do
  let!(:user) { create :user, email: "jd@gmail.com", first_name: "John", last_name: "Doe" }
  let!(:order) { create :order, user:, customer_address: "Customer Address" }

  before { assign(:order, order) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/jd@gmail.com/)
    expect(rendered).to match(/John Doe/)
    expect(rendered).to match(/Customer Address/)
  end
end
