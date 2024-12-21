# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    order
    product
    stock { association(:stock, product:) }
    order_code { order.order_code }
    product_name { product.name }
    product_price { product.price }
    size { stock.size }
    quantity { 2 }
  end
end
