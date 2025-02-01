# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :active, -> { where(active: true) }

  def self.literal_enum(name = nil, values = nil, **)
    values = values.to_h { |value| [value] * 2 } if values.is_a?(Array)

    enum(name, values, validate: true, **)
  end

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end
