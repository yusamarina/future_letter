class HomeController < ApplicationController
  skip_before_action :login_required, only: %i[top privacy terms]

  def top; end

  def privacy; end

  def terms; end

  def description; end

  def mypage
    @send_letters = current_user.letters.joins(:send_letters)
    @received_letters = Letter.joins(:send_letters).where(send_letters: { destination_id: current_user.id })
    @anniversaries = Anniversary.where(user_id: current_user.id).includes(:user)
  end

  def friend
    render layout: 'login'
  end
end
