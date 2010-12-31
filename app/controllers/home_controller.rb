class HomeController < ApplicationController
  before_filter :require_userish

  def require_userish
    @current_user = User.first
  end

  def index
    
  end
end
