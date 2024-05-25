# frozen_string_literal: true

# This custom class handles the redirection when the application
# encounters session timeout.
module Devise
  class CustomFailureApp < Devise::FailureApp
    # You need to override respond to eliminate recall
    def respond
      http_auth? ? http_auth : redirect
    end

    def redirect
      store_location!
      if flash[:timedout] && flash[:alert]
        flash.keep(:timedout)
        flash.keep(:alert)
      else
        flash[:alert] = i18n_message
      end
      redirect_to redirect_url
    end

    def redirect_url # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      if warden_message == :timeout
        flash[:timedout] = true
        session[:return_to] = attempted_path unless request.xhr?

        if warden_options[:scope] == :user
          new_user_session_path
        else
          # Remove the Timeout alert message.
          flash[:alert] = nil
          root_path
        end
      else
        path = request.get? ? attempted_path : request.referer

        if path_valid?(path)
          path || scope_url
        elsif warden_options[:scope] == :user
          new_user_session_path
        else
          root_path
        end
      end
    end

    private

    def path_valid?(path)
      return false if path.blank?

      uri = URI.parse(path)
      uri.host == request.host
    end
  end
end
