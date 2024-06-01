# frozen_string_literal: true

module AdminSidebarHelper
  def sidebar_link_active_class(kontroller)
    controller_name == kontroller ? "rounded bg-gray-900" : ""
  end
end
