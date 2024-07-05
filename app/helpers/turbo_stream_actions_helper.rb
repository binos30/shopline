# frozen_string_literal: true

module TurboStreamActionsHelper
  # Custom turbo stream action for redirecting to a url
  # `<turbo-stream url="url" action="redirect"><template></template></turbo-stream>`
  def redirect(url)
    turbo_stream_action_tag :redirect, url:
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
