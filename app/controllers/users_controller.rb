class UsersController < ApplicationController
    def generate_token
        @user = User.find_or_create_by(email: params[:email])
        render json: {
            "token": @user.api_token
        }
    end
end