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

  scope :recent_unfulfilled, -> { where(fulfilled: false).order(created_at: :desc).take(5) }
  scope :revenue, -> { where(created_at: Time.current.midnight..Time.current).sum(:total) }
  scope :sales, -> { where(created_at: Time.current.midnight..Time.current).count }
  scope :avg_sale, -> { where(created_at: Time.current.midnight..Time.current).average(:total) }
  scope :per_sale, -> { where(created_at: Time.current.midnight..Time.current).average(:quantity) }
end
