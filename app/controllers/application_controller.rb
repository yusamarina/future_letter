class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  before_action :login_required

  rescue_from StandardError, with: :render500
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from ActionController::RoutingError, with: :render404

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

  def render404
    render file: Rails.root.join('public/404.html'), layout: false, status: :not_found
  end

  def render500(error = nil)
    logger.error(error.message)
    logger.error(error.backtrace.join('\n'))
    ExceptionNotifier.notify_exception(e, env: request.env, data: { message: 'error' })
    render file: Rails.root.join('public/500.html'), layout: false, status: :internal_server_error
  end
end
