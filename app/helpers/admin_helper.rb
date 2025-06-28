# frozen_string_literal: true

module AdminHelper
  ACTIVE_LABEL = "Active"
  INACTIVE_LABEL = "Inactive"
  STATUS_ACTIVE_CLASS =
    "bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-sm dark:bg-green-900 dark:text-green-300"
  STATUS_INACTIVE_CLASS =
    "bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded-sm dark:bg-red-900 dark:text-red-300"
  STATUS_UNFULFILLED_CLASS =
    "bg-yellow-100 text-yellow-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-sm dark:bg-yellow-900 dark:text-yellow-300" # rubocop:disable Layout/LineLength

  def sidebar_link_active_class(kontroller)
    kontroller.include?(controller_name) ? "bg-gray-100 dark:bg-gray-700" : ""
  end

  def sidebar_link_icon_active_class(kontroller)
    kontroller.include?(controller_name) ? "text-gray-900 dark:text-white" : ""
  end

  def status_badge(is_active)
    tag.span(
      is_active ? ACTIVE_LABEL : INACTIVE_LABEL,
      class: is_active ? STATUS_ACTIVE_CLASS : STATUS_INACTIVE_CLASS
    )
  end

  def order_status_badge(is_fulfilled)
    tag.span(
      is_fulfilled ? "Fulfilled" : "Unfulfilled",
      class: is_fulfilled ? STATUS_ACTIVE_CLASS : STATUS_UNFULFILLED_CLASS
    )
  end
end
