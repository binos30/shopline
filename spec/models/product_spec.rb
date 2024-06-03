# frozen_string_literal: true

require "rails_helper"

RSpec.describe Product do
  let!(:category) { Category.create!(name: "Category") }

  it "does not save without name" do
    product = described_class.new(category:)
    expect(product.save).to be false
  end

  it "does not save without category" do
    product = described_class.new(name: "Product")
    expect(product.save).to be false
  end

  it "saves" do
    product = described_class.new(name: "Product", category:)
    expect(product.save).to be true
  end
end
