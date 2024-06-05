# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :product_name,
            :size,
            :customer_email,
            :customer_full_name,
            :customer_address,
            presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than_or_equal: 10 }
  validates :product_price,
            presence: true,
            numericality: {
              greater_than_or_equal: 0,
              less_than_or_equal: 999_999_999
            }
end
