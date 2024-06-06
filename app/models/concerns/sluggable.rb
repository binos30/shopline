# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    class_attribute :sluggable_attribute

    def self.slugify(attribute)
      self.sluggable_attribute = attribute.to_sym
      friendly_id sluggable_attribute
    end

    # Whether to generate a new slug.
    def should_generate_new_friendly_id?
      slug.blank? || send(:"#{sluggable_attribute}_changed?")
    end
  end
end
