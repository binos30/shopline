# frozen_string_literal: true

class Role < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            length: {
              minimum: 2,
              maximum: 40
            },
            format: /\A([^\d\W]|-|\s)*\z/
end
