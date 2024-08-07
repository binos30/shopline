# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :product

  broadcasts_refreshes_to :product
  broadcasts_refreshes

  validates :size, presence: true, uniqueness: { scope: :product_id, case_sensitive: false }
  validates :quantity,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 999_999_999
            }
end
