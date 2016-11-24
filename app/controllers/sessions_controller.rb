class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :verify_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(login: params[:session][:login])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to visits_path
    else
      flash[:danger] = 'Combinaison login/mot de passe invalide'
      redirect_to root_path
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_url
  end

  def verify_login
    if logged_in?
      redirect_to visits_url
    end
  end

end
