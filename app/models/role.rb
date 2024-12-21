# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :users, inverse_of: :role, dependent: :restrict_with_exception

  validates :name,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            length: {
              in: 2..40
            },
            format: /\A([^\d\W]|-|\s)*\z/
end
