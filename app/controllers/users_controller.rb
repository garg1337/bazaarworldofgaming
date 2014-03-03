class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Registration was successful!"
      redirect_to signin_path
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :username, :password,
                                   :password_confirmation)
    end
end
