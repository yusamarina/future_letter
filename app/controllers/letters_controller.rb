class LettersController < ApplicationController
  skip_before_action :login_required, only: %i[open]
  before_action :set_letter, only: %i[edit update destroy]

  require 'net/http'
  require 'uri'

  def index
    @letters = Letter.where(user_id: current_user.id).includes(:user).order("created_at DESC")
  end

  def show; end

  def invite
    @user = User.find(session[:user_id])
    @letter = Letter.find_by(token: params[:token])
    render layout: 'login'
  end

  def reserve
    @letter = Letter.find(params[:id])
    @letter.save!(validate: false)
    render json: @letter
    message = {
      "type": "text",
      "text": "手紙の宛先が確認されました！\n設定日時にお手紙が相手へ届きます。"
    }
    client = Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(@letter.user.line_user_id, message)
    p response
    message = {
      "type": "text",
      "text": "お手紙はサプライズで届きます！\nお楽しみに...!"
    }
    client = Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(User.find(session[:user_id]).line_user_id, message)
    p response
  end

  def new
    @letter = Letter.new
  end

  def create
    @letter = Letter.new(letter_params)
    @letter.user_id = current_user.id
    @letter.token = SecureRandom.hex(32)
    if @letter.save
      render json: @letter
    else
      respond_to do |format|
        format.js { render 'create', status: 400 }
      end
    end
  end

  def message
    message = {
      "type": 'text',
      "text": "お手紙の宛先確認メッセージを送りました！\nお返事があるまでお待ちください。",
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(current_user.line_user_id, message)
    p response
  end

  def edit; end

  def update
    if @letter.update(letter_params)
      render json: @letter
    else
      respond_to do |format|
        format.js { render 'update', status: 400 }
      end
    end
  end

  def destroy
    @letter.destroy!
    respond_to do |format|
      format.html { redirect_to letters_url }
      format.json { head :no_content }
    end
  end

  def open
    render layout: 'login'
  end

  private

  def set_letter
    @letter = Letter.find(params[:id])
    user = @letter.user
    if user != current_user
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found }
      end
    end
  end

  def letter_params
    params.require(:letter).permit(:title, :body, :image, :user_id, :template_id, :token, :send_date)
  end
end
