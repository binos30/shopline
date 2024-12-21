# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    role
    first_name { "John" }
    last_name { "Doe" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }
    gender { "male" }

    trait :as_admin do
      role { association(:role, :as_admin) }
    end
  end
end
