# frozen_string_literal: true

module AdminHelper
  ACTIVE_LABEL = "Active"
  INACTIVE_LABEL = "Inactive"
  STATUS_ACTIVE_CLASS =
    "bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-green-900 dark:text-green-300"
  STATUS_INACTIVE_CLASS =
    "bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-red-900 dark:text-red-300"
  STATUS_UNFULFILLED_CLASS =
    "bg-yellow-100 text-yellow-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded dark:bg-yellow-900 dark:text-yellow-300" # rubocop:disable Layout/LineLength

  def sidebar_link_active_class(kontroller)
    kontroller.include?(controller_name) ? "bg-gray-100 dark:bg-gray-700" : ""
  end

  def sidebar_link_icon_active_class(kontroller)
    kontroller.include?(controller_name) ? "text-gray-900 dark:text-white" : ""
  end

  def sidebar_link_class
    "flex items-center p-2 text-gray-900 rounded-lg dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group"
  end

  def sidebar_link_icon_class
    "flex-shrink-0 w-5 h-5 text-gray-500 transition duration-75 dark:text-gray-400" \
      " group-hover:text-gray-900 dark:group-hover:text-white"
  end

  def h1_label_class
    "text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white"
  end

  def strong_label_class
    "block mb-1 font-medium text-gray-900 dark:text-white"
  end

  def span_label_class
    "text-gray-900 dark:text-white"
  end

  def form_label_class
    "block mb-2 text-sm font-medium text-gray-900 dark:text-white"
  end

  def form_input_class
    "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600" \
      " focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600" \
      " dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
  end

  def form_button_class
    "cursor-pointer w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none" \
      " focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600" \
      " dark:hover:bg-primary-700 dark:focus:ring-primary-800"
  end

  def new_record_button_with_icon_class
    "text-center inline-flex items-center text-white bg-primary-600 hover:bg-primary-700 focus:ring-4" \
      " focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5" \
      " dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
  end

  def button_with_icon_class
    "text-center inline-flex items-center border border-gray-300 text-white bg-gray-800 hover:bg-gray-900" \
      " focus:outline-none focus:ring-4 focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2" \
      " dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700"
  end

  def delete_button_with_icon_class
    "text-center inline-flex items-center border border-red-300 text-white bg-red-800 hover:bg-red-900" \
      " focus:outline-none focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2" \
      " dark:bg-red-800 dark:hover:bg-red-700 dark:focus:ring-red-700 dark:border-red-700"
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
