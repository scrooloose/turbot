class SignupsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(signup_params)

    if @user.save
      auto_login(@user)
      redirect_to new_template_message_setup_path, notice: "Registration successful! Time to set up your messages!"
    else
      flash.now[:alert] = "Please correct the errors shown and try again"
      render :new
    end

  end

private

  def signup_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :pof_username, :pof_password)
  end
end
