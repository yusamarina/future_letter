class SendLettersController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
  end

  def show
  end

  def new
  end

  def create
    idToken = params[:idToken]
    channelId = ENV['CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),
                          {'id_token'=>idToken, 'client_id'=>channelId})
    render :json => res.body
    destination_id = params[:dataId]
    letter = Letter.find_by(token: params[:letterToken])
    send_letter = SendLetter.new(destination_id: destination_id ,letter_id: letter.id)
    send_letter.save! if SendLetter.find_by(letter_id: letter.id) == nil
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
