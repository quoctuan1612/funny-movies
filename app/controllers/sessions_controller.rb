class SessionsController < ApplicationController
  def create
    user = User.find_or_initialize_by(user_name: params[:user_name])

    if user.persisted?
      login(user)
    else
      register(user)
    end

    redirect_to root_path
  end

  def logout
    session[:user_id] = nil

    redirect_to root_path
  end

  private

  def login user
    if user.password == params[:password]
      session[:user_id] = user.id
      flash[:success] = "Login Success!"
    else
      flash[:danger] = "Wrong password!"
    end
  end

  def register user
    user.password = params[:password]
    
    if user.save
      flash[:success] = "register success!"
    else
      flash[:danger] = "Username/Password can't blank!"
    end
  end
end
