class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user_session][:email], params[:user_session][:password])
      redirect_to dashboards_path, notice: 'Login successful'
    else
      flash.now[:alert] = 'Welcome Back!'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: 'Logged out!')
  end
end
