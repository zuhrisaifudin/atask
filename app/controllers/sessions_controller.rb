class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { message: 'Login Berhasil' }, status: :ok
      else
        render json: { error: 'Email atau Password Salah' }, status: :unauthorized
      end
    end
  
    def destroy
      session[:user_id] = nil
      render json: { message: 'Logout berhasil Keluar' }, status: :ok
    end
  end
  