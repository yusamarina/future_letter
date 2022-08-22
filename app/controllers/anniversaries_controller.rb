class AnniversariesController < ApplicationController
  before_action :set_anniversary, only: %i[show edit update destroy]

  def index
    @anniversaries = Anniversary.where(user_id: current_user.id).includes(:user).order('date DESC')
  end

  def show; end

  def new
    @anniversary = Anniversary.new
  end

  def create
    @anniversary = Anniversary.new(anniversary_params)
    @anniversary.user = current_user
    if @anniversary.save
      render json: @anniversary
    else
      respond_to do |format|
        format.js { render 'create', status: 400 }
      end
    end
  end

  def edit; end

  def update
    if @anniversary.update(anniversary_params)
      render json: @anniversary
    else
      respond_to do |format|
        format.js { render 'update', status: 400 }
      end
    end
  end

  def destroy
    @anniversary.destroy!
  end

  private

  def anniversary_params
    params.require(:anniversary).permit(:user_id, :name, :date, :description)
  end

  def set_anniversary
    @anniversary = Anniversary.find(params[:id])
    user = @anniversary.user
    if user != current_user
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found }
      end
    end
  end
end
