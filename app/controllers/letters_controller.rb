class LettersController < ApplicationController
  skip_before_action :login_required, only: %i[open confirm]
  before_action :set_letter, only: %i[edit update destroy]

  require 'net/http'
  require 'uri'

  def index
    @letters = Letter.where(user_id: current_user.id, send_letters: { letter_id: nil }).includes(:send_letters, :user).order('send_date ASC')
  end

  def invite
    @letter = Letter.find_by(token: params[:token])
    render layout: 'login'
  end

  def reserve
    letter = Letter.find(params[:id])
    letter.save!(validate: false)
    render json: letter
    message = {
      "type": 'text',
      "text": "お手紙の宛先が確認されました$\n設定日時に相手へお手紙が届きます！お楽しみに$",
      "emojis": [
        {
          "index": 14,
          "productId": "5ac22bad031a6752fb806d67",
          "emojiId": "186"
        },
        {
          "index": 38,
          "productId": "5ac22bad031a6752fb806d67",
          "emojiId": "143"
        }
      ]
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(letter.user.line_user_id, message)
    p response
    message = {
      "type": 'text',
      "text": "お手紙はサプライズで届きます！\nお届けまでお楽しみに$$",
      "emojis": [
        {
          "index": 26,
          "productId": "5ac22bad031a6752fb806d67",
          "emojiId": "070"
        },
        {
          "index": 27,
          "productId": "5ac22bad031a6752fb806d67",
          "emojiId": "189"
        }
      ]
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
      "text": "お手紙の宛先確認メッセージを送りました$\n相手が送信を許可するまでお待ちください！$",
      "emojis": [
        {
          "index": 19,
          "productId": "5ac2197b040ab15980c9b43d",
          "emojiId": "027"
        },
        {
          "index": 41,
          "productId": "5ac2173d031a6752fb806d56",
          "emojiId": "202"
        }
      ]
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(current_user.line_user_id, message)
    p response
  end

  def edit
    if SendLetter.where(letter_id: @letter.id).present?
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found }
      end
    end
  end

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
  end

  def open
    render layout: 'login'
  end

  def confirm
    render layout: 'login'
  end

  private

  def letter_params
    params.require(:letter).permit(:title, :body, :image, :remove_image, :user_id, :template_id, :token, :send_date)
  end

  def set_letter
    @letter = Letter.find(params[:id])
    user = @letter.user
    if user != current_user
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found }
      end
    end
  end
end
