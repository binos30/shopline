# frozen_string_literal: true

class AdminController < ApplicationController
  layout "admin"

  before_action :check_and_authenticate_user
  before_action :authenticate_user!
  before_action :check_access

  ITEMS_PER_PAGE_ARRAY = [10, 25, 50, 100].freeze

  private

  def check_and_authenticate_user
    session[:return_to] = request.url
    redirect_to new_user_session_path unless user_signed_in?
  end

  def check_access
    return if current_user.admin?
    redirect_to root_url, warning: t(:no_permission, controller_name: controller_name.titleize)
  end

  def count_per_page
    ITEMS_PER_PAGE_ARRAY.find { |el| el == params[:count_per_page].to_i } || 10
  end
end
