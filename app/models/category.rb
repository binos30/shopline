# frozen_string_literal: true

class Category < ApplicationRecord
  include Filterable
  include Sluggable

  # Set the attribute from which the slug would be generated
  slugify :name

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end

  has_many :products, inverse_of: :category, dependent: :destroy

  has_rich_text :description

  broadcasts_refreshes

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :image, content_type: %i[jpeg jpg png webp], size: { less_than_or_equal_to: 3.megabytes }

  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
end
