# frozen_string_literal: true

module ApplicationHelper
  def title(page_title)
    content_for :title, "#{t(:title)} | #{page_title}"
  end

  # Returns a date in the format specified.
  def format_date(date_instance, format = "%b %e, %Y")
    date =
      if date_instance.is_a?(String)
        DateTime.parse(date_instance)
      elsif date_instance.is_a?(Date)
        # We are converting Date to DateTime class to
        # avoid error in TimeZone conversion.
        date_instance.to_datetime
      else
        date_instance
      end

    date.blank? ? "" : date.localtime.strftime(format)
  end
end
