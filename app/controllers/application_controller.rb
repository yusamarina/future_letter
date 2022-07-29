class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  before_action :login_required

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def login_required
    redirect_to top_path unless current_user
  end
end
