class UsersController < ApplicationController
   skip_before_action :verify_authenticity_token, only: [:create]

    def index
    @users = User.all
    render json: @users
    end

    def show
    @user = User.find(params[:id])
    render json: @user
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user.as_json(except: [:password_digest]), status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
    
    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
