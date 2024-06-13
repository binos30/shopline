# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :stock

  validates :order_code, :product_name, :size, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_price, presence: true, numericality: { greater_than_or_equal: 0 }
end
