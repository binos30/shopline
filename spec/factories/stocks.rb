# frozen_string_literal: true

FactoryBot.define do
  factory :stock do
    product
    sequence(:size) { |n| "SZ #{n}" }
    quantity { 50 }
  end
end
