class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  def require_login
    unless logged_in?
      #flash[:danger] = "Vous devez vous connecter pour accéder à cette page."
      redirect_to root_url
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
      !current_user.nil?
  end
end
