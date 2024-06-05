# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  layout "devise"

  # GET /login
  def new
    session[:return_to] = params[:return_to] if params[:return_to].present?
    super
  end

  # POST /login
  def create
    super
    flash.discard(:notice) # Remove the signed in successfully messsage.
  end

  # DELETE /logout
  def destroy
    super
    session.delete(:return_to)
    flash.discard(:notice) # Remove the signed out successfully messsage.
  end

  # Overwriting the sign_in redirect path method
  def after_sign_in_path_for(_resource)
    root_path
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_resource)
    new_user_session_path
  end
end
