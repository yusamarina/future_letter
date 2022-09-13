class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :login_required, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]
  layout 'admin/layouts/admin_login'

  require 'net/http'
  require 'uri'

  def new; end

  def create
    id_token = params[:idToken]
    channel_id = ENV['ADMIN_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'), { 'id_token' => id_token, 'client_id' => channel_id })
    line_user_id = JSON.parse(res.body)['sub']
    user = User.find_by(line_user_id: line_user_id)
    session[:user_id] = user.id
    render json: user
  end

  def destroy
    session[:user_id] = nil
    redirect_to top_path
  end
end
