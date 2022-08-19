class SendLettersController < ApplicationController
  skip_before_action :login_required, only: %i[login]
  before_action :set_letter, only: %i[destroy]

  require 'net/http'
  require 'uri'

  def login
    render layout: 'login'
  end

  def index
    user = current_user
    @send_letters = user.letters.joins(:send_letters).order('send_date DESC')
  end

  def show
    @letter = Letter.find_by(token: params[:token])
    send_letter = SendLetter.find_by(letter_id: @letter.id)
    if @letter.user || send_letter.destination == current_user
      render layout: 'login'
    else
      redirect_to(top_path) 
    end
  end

  def new; end

  def create
    id_token = params[:idToken]
    channel_id = ENV['CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'), { 'id_token' => id_token, 'client_id' => channel_id })
    render json: res.body
    destination_id = params[:dataId]
    letter = Letter.find_by(token: params[:letterToken])
    send_letter = SendLetter.new(destination_id: destination_id, letter_id: letter.id)
    send_letter.save! if SendLetter.find_by(letter_id: letter.id) == nil
  end

  def destroy
    @send_letter.destroy!
  end

  private

  def set_letter
    @send_letter = Letter.find(params[:id])
    user = @send_letter.user
    if user != current_user
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found }
      end
    end
  end
end
