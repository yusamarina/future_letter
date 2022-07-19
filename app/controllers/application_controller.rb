class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_liff_id
    gon.liff_id = ENV['LIFF_ID']
  end
end
