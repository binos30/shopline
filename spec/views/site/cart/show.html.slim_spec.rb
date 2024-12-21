# frozen_string_literal: true

require "rails_helper"

RSpec.describe "site/cart/show.html.slim", type: :view do
  it "renders cart label" do
    render
    expect(rendered).to match(/cart/)
  end
end
