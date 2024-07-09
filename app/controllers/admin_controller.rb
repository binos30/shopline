# frozen_string_literal: true

class AdminController < ApplicationController
  layout "admin"

  before_action :check_and_authenticate_user
  before_action :authenticate_user!
  before_action :check_access

  private

  def check_and_authenticate_user
    session[:return_to] = request.url
    redirect_to new_user_session_path unless user_signed_in?
  end

  def check_access
    return if current_user.admin?
    redirect_to root_url, warning: t(:no_permission, controller_name: controller_name.titleize)
  end
end
