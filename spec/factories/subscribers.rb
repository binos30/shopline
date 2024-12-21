# frozen_string_literal: true

FactoryBot.define do
  factory :subscriber do
    sequence(:email) { |n| "user-#{n}@example.com" }
  end
end
