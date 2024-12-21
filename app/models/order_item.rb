# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :product, inverse_of: :order_items
  belongs_to :stock, inverse_of: :order_items

  validates :order_code, :product_name, :size, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
