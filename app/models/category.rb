# frozen_string_literal: true

class Category < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
