# frozen_string_literal: true

require "rails_helper"

RSpec.describe Role do
  it "does not save without name" do
    role = described_class.new
    expect(role.save).to be false
  end

  it "saves" do
    role = described_class.new(name: "Administrator")
    expect(role.save).to be true
  end
end
