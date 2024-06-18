# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

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

  # rubocop:disable Rails/OutputSafety
  def items_option_selected
    case params[:count_per_page]
    when "100"
      "<option value='10'>Show 10</option>
      <option value='25'>Show 25</option>
      <option value='50'>Show 50</option>
      <option value='100' selected>Show 100</option>".html_safe
    when "50"
      "<option value='10'>Show 10</option>
      <option value='25'>Show 25</option>
      <option value='50' selected>Show 50</option>
      <option value='100'>Show 100</option>".html_safe
    when "25"
      "<option value='10'>Show 10</option>
      <option value='25' selected>Show 25</option>
      <option value='50'>Show 50</option>
      <option value='100'>Show 100</option>".html_safe
    else
      "<option value='10' selected>Show 10</option>
      <option value='25'>Show 25</option>
      <option value='50'>Show 50</option>
      <option value='100'>Show 100</option>".html_safe
    end
  end
  # rubocop:enable Rails/OutputSafety
end
