class LoginController < ApplicationController
  def index
  end

  def auth
    username = params[:session][:username]
    password = params[:session][:password]

    user = User.find_by(username: username)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to data_upload_path
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to login_path
    end
  end

  def logout
    session.delete(:user_id)
    flash[:success] = 'You have been logged out'
    redirect_to login_path
  end
end
