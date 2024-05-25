# frozen_string_literal: true

class AdminController < ApplicationController
  layout "admin"

  before_action :check_and_authenticate_user
  before_action :authenticate_user!

  def index
  end

  private

  def check_and_authenticate_user
    session[:return_to] = request.url
    redirect_to new_user_session_path unless user_signed_in?
  end

  def access?(role_ids = [])
    return false unless role_ids.exclude?(current_user.role_id.to_i)

    redirect_to redirection_url, error: no_permission
  end

  def no_permission
    "You don't have enough permission to access <strong>#{controller_name.titleize}</strong>."
  end
end
