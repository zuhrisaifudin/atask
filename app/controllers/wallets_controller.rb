class WalletsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :authenticate_user

  def show
    wallet = current_user.wallet
    if wallet
      render json: wallet
    else
      render json: { error: 'Wallet tidak ditemukan' }, status: :not_found
    end
  end

  def update
    wallet = current_user.wallet
    amount = params[:amount].to_f

    if params[:amount].nil? || amount <= 0
      render json: { error: 'Jumlah Salah. Masukan Jumlah yang benar.' }, status: :unprocessable_entity
      return
    end

    wallet.update_balance!(amount)
    render json: wallet
  end

  private

  def authenticate_user
    unless current_user
      render json: { error: 'Tidak diizinkan proses ini' }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
