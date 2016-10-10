class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login: params[:session][:login])
    if user && user.authenticate(params[:session][:password])
      redirect_to visits_path
    else
      flash[:danger] = 'Combinaison login/mot de passe invalide'
      redirect_to root_path
    end
  end

  def destroy
  end


end
