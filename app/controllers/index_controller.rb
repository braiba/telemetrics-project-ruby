class IndexController < ApplicationController
  def index
    if !logged_in?
      redirect_to login_path
    else
      redirect_to data_upload_path
    end
  end
end
