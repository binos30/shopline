# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :warning

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name gender])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name gender])
  end

  # Render turbo stream with our custom action `redirect` to solve "Turbo frame break out + redirect" problem.
  def turbo_stream_redirect(url, flash_type: :alert, flash_message: "")
    raise ArgumentError, "Invalid flash type '#{flash_type}'" unless flash_type.in?(%i[alert notice warning])
    respond_to do |format|
      format.turbo_stream do
        if flash_message
          flash.now[flash_type] = flash_message
          flash.keep(flash_type)
        end
        render turbo_stream: turbo_stream.redirect(url)
      end
    end
  end

  private

  def count_per_page
    [10, 25, 50, 100].find { |el| el == params[:count_per_page].to_i } || 10
  end
end
