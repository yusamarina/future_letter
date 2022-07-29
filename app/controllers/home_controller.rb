class HomeController < ApplicationController
  skip_before_action :login_required, only: %i[top privacy terms]

  def top; end

  def privacy; end

  def terms; end

  def description; end

  def mypage; end
end
