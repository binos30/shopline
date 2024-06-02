# frozen_string_literal: true

module Sanitizable
  extend ActiveSupport::Concern

  included { include ActionView::Helpers::SanitizeHelper }
end
