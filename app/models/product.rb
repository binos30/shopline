# frozen_string_literal: true

class Product < ApplicationRecord
  include Filterable
  include Sluggable

  # Set the attribute from which the slug would be generated
  slugify :name

  belongs_to :category, inverse_of: :products

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :medium, resize_to_limit: [250, 250]
  end
  has_many :stocks, inverse_of: :product, dependent: :destroy
  has_many :order_items, inverse_of: :product, dependent: :restrict_with_exception

  has_rich_text :description

  broadcasts_refreshes_to :category
  broadcasts_refreshes

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, numericality: { in: 0..999_999_999 }
  validates :images, content_type: %i[jpeg jpg png webp], size: { less_than_or_equal_to: 3.megabytes }

  scope :available, -> { joins(:stocks).where("quantity > 0").distinct }
  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :filter_by_min, ->(min) { where(price: min..) }
  scope :filter_by_max, ->(max) { where(price: ..max) }
end
