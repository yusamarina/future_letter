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
    register_letter = RegisterLetterService.new(letter, current_user)
    register_letter.call
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
    push_message = PushMessageService.new(current_user)
    push_message.call
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
    params.require(:letter).permit(:title, :body, :image, :remove_image, :user_id, :template_id, :token, :send_date, :sender_name)
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
