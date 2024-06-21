# frozen_string_literal: true

module EnumI18nHelper
  # Returns an array of the possible key/i18n values for the enum
  # Example usage:
  # enum_for_select(User, :approval_state)
  def enum_for_select(klass, enum, hash = {})
    return [] if hash.nil?

    if hash.empty?
      enum_instance = klass.send(enum.to_s.pluralize)
      enum_instance.keys.collect { |key| [klass.human_enum_name(enum, key), key] }
    else
      hash.keys.collect { |key| [klass.human_enum_name(enum, key), key] }
    end
  end
end
