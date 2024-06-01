# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category do
  it "does not save without name" do
    category = described_class.new
    expect(category.save).to be false
  end

  it "saves" do
    category = described_class.new(name: "Category")
    expect(category.save).to be true
  end
end
