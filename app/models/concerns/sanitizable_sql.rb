# frozen_string_literal: true

module SanitizableSql
  extend ActiveSupport::Concern

  module ClassMethods
    def self.sanitize_sql(param)
      ActiveRecord::Base.sanitize_sql(param)
    end
  end
end
