# frozen_string_literal: true

module AdminHelper
  ACTIVE_LABEL = "Active"
  INACTIVE_LABEL = "Inactive"
  STATUS_ACTIVE_CLASS =
    "bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-green-900 dark:text-green-300"
  STATUS_INACTIVE_CLASS =
    "bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-red-900 dark:text-red-300"

  def sidebar_link_active_class(kontroller)
    kontroller.include?(controller_name) ? "rounded bg-gray-900" : ""
  end

  def status_badge(is_active)
    tag.span(
      is_active ? ACTIVE_LABEL : INACTIVE_LABEL,
      class: is_active ? STATUS_ACTIVE_CLASS : STATUS_INACTIVE_CLASS
    )
  end
end
