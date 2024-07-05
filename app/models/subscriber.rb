# frozen_string_literal: true

class Subscriber < ApplicationRecord
  include Filterable

  validates :email,
            presence: true,
            length: {
              maximum: 255
            },
            uniqueness: {
              case_sensitive: false
            },
            format: {
              with: Devise.email_regexp
            }

  scope :filter_by_email, ->(email) { where("email ILIKE ?", "%#{email}%") }
end
