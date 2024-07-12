# frozen_string_literal: true

class Category < ApplicationRecord
  include Filterable
  include Sanitizable
  include Sluggable

  # Set the attribute from which the slug would be generated
  slugify :name

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end
  has_many :products, dependent: :destroy

  broadcasts_refreshes

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :image, content_type: %i[jpeg jpg png webp], size: { less_than_or_equal_to: 3.megabytes }

  before_save :sanitize_fields

  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  private

  def sanitize_fields
    self.description = sanitize(description, scrubber: HtmlScrubbers::WysiwygScrubber.new)
  end
end
