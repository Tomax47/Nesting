class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "welcome "+@user.username
    else
      redirect_to users_new_path, @user.errors.full_messages.to_s
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
