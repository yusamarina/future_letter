class SendLettersController < ApplicationController
  skip_before_action :login_required, only: %i[login]

  require 'net/http'
  require 'uri'

  def login
    render layout: 'login'
  end

  def index
    user = current_user
    @send_letters = user.letters.joins(:send_letters).order('send_date DESC')
  end

  def received
    user = current_user
    @received_letters = Letter.joins(:send_letters).where(send_letters: { destination_id: user.id }).order('send_date DESC')
  end

  def show
    @letter = Letter.find_by(token: params[:token])
    send_letter = SendLetter.find_by(letter_id: @letter.id)
    if @letter.user == current_user
      render layout: 'login'
    elsif send_letter.destination_id == current_user.id
      render layout: 'login'
    else
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found }
      end
    end
  end

  def new; end

  def create
    set_destination = SetDestinationService.new(params[:idToken])
    set_destination.call
    render json: set_destination.res_body
    destination_id = params[:dataId]
    letter = Letter.find_by(token: params[:letterToken])
    send_letter = SendLetter.new(destination_id: destination_id, letter_id: letter.id)
    send_letter.save! if SendLetter.find_by(letter_id: letter.id) == nil
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
