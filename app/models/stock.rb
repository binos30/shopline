# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :product, touch: true

  broadcasts_refreshes

  validates :size, presence: true, uniqueness: { scope: :product_id, case_sensitive: false }
  validates :quantity,
            presence: true,
            numericality: {
              greater_than_or_equal: 0,
              less_than_or_equal: 999_999_999
            }
end
