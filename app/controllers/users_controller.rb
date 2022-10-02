class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[new create]

  require 'net/http'
  require 'uri'

  def new
    render layout: 'login'
  end

  def create
    line_user_authenticate = LineUserAuthenticateService.new(params[:idToken])
    line_user_authenticate.call
    user = line_user_authenticate.search_user
    if user.nil?
      user = User.create(line_user_id: line_user_authenticate.line_user_id)
      session[:user_id] = user.id
      render json: user, layout: 'login'
    elsif user
      session[:user_id] = user.id
      render json: user, layout: 'login'
    end
  end
end
