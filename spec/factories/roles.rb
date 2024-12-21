# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { "Customer" }

    trait :as_admin do
      name { "Administrator" }
    end
  end
end
