# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stock do
  let!(:category) { Category.create!(name: "Category") }
  let!(:product) { Product.create!(name: "Product", category:) }

  it "does not save without product" do
    stock = described_class.new(size: 10, quantity: 5)
    expect(stock.save).to be false
  end

  it "saves" do
    stock = described_class.new(size: 10, quantity: 5, product:)
    expect(stock.save).to be true
  end
end
