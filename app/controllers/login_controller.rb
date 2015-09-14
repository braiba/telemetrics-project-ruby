class LoginController < ApplicationController

  skip_before_filter :require_login

  def index
  end

  def auth
    username = params[:login][:username]
    password = params[:login][:password]

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
    session.delete(:journey_id)
    flash[:success] = 'You have been logged out'
    redirect_to login_path
  end
end
