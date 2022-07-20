class LettersController < ApplicationController
  before_action :set_letter, only: %i[ show edit update destroy ]

  require 'net/http'
  require 'uri'

  def index
    @letters = Letter.all
  end

  def show;  end

  def new
    @letter = Letter.new
  end

  def create
    user = current_user
    @letter = Letter.new(letter_params)
    @letter.user_id = user.id
    @letter.token = SecureRandom.hex(32)
    if @letter.save
      render json: @letter
    else
      respond_to do |format|
        format.js { render 'create', status: 400 }
        format.js { render 'create' }
      end
    end
  end

  def message
    message = {
      "type": "text",
      "text": "お手紙を送りました！\n送信日までお待ちください！",
    }
    client = Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(current_user.line_user_id, message)
    p response
  end

  def edit
    @letter = Letter.find_by(token: params[:token])
  end

  def update
    respond_to do |format|
      if @letter.update(letter_params)
        format.html { redirect_to letter_url(@letter), notice: "Letter was successfully updated." }
        format.json { render :show, status: :ok, location: @letter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @letter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: "Letter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_letter
      @letter = Letter.find(params[:id])
    end

    def letter_params
      params.require(:letter).permit(:title, :body, :image, :user_id, :template_id, :token)
    end

end
