class HomeController < ApplicationController
  before_filter :require_userish

  def require_userish
    @current_user = User.first
  end

  def index
	render 'paras' unless ENV['RAILS_ENV'] == 'development'
  end
end
