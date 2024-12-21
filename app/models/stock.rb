# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :product, inverse_of: :stocks

  has_many :order_items, inverse_of: :stock, dependent: :restrict_with_exception

  broadcasts_refreshes_to :product
  broadcasts_refreshes

  validates :size, presence: true, uniqueness: { scope: :product_id, case_sensitive: false }
  validates :quantity, presence: true, numericality: { only_integer: true, in: 0..999_999_999 }
end
