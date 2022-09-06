class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout 'admin/layouts/application'

  private

  def check_admin
    redirect_to top_path unless current_user.admin?
  end
end
