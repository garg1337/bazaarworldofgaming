class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(username: params[:session][:username])
  		if user && user.authenticate(params[:session][:password])
    		sign_in user
    		flash.now[:success] = 'Login Successful'
    		redirect_to root_path
  		else
    		flash.now[:error] = 'Invalid username or password'
      		render 'new'
  		end
	end

	def destroy
	end
end
