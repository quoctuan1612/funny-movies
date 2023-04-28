class ApplicationController < ActionController::Base
  private
  
  def authenticate
    return redirect_to root_path if session[:user_id].blank?
  end
end
