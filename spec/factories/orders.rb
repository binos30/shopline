# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user
    customer_email { user.email }
    customer_full_name { user.full_name }
    customer_address { "my address 1" }

    transient { items_count { 2 } }

    after(:build) do |order, evaluator|
      product = create(:product, :with_stocks)
      build_list(:order_item, evaluator.items_count, order:, product:)
    end
  end
end
