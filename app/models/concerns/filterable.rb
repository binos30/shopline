# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    include SanitizableSql

    def filters(filtering_params)
      results = where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(:"filter_by_#{key}", sanitize_sql(value)) if value.present?
      end
      results
    end
  end
end
