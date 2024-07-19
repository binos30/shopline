# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Homepage" do
  it "passes" do
    visit root_path

    expect(page).to have_content "Welcome"
  end
end
