class Demo::BaseController < ApplicationController
  skip_before_action :login_required
  layout 'demo/layouts/application'
end
