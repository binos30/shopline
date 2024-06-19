# frozen_string_literal: true

class Product < ApplicationRecord
  include Filterable
  include Sanitizable
  include Sluggable

  # Set the attribute from which the slug would be generated
  slugify :name

  belongs_to :category

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :medium, resize_to_limit: [250, 250]
  end
  has_many :stocks, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal: 0,
              less_than_or_equal: 999_999_999
            }

  before_save :sanitize_fields

  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :filter_by_min, ->(min) { where("price >= ?", min) }
  scope :filter_by_max, ->(max) { where("price <= ?", max) }

  private

  def sanitize_fields
    self.description = sanitize(description, scrubber: HtmlScrubbers::WysiwygScrubber.new)
  end
end
