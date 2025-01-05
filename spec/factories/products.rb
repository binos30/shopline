# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    category
    sequence(:name) { |n| "Product #{n}" }
    description { "Description" }
    price { 100 }

    trait :with_stocks do
      transient { stocks_count { 2 } }

      after(:build) { |product, evaluator| build_list(:stock, evaluator.stocks_count, product:) }
      after(:stub) { |product, evaluator| build_stubbed_list(:stock, evaluator.stocks_count, product:) }
    end
  end
end
