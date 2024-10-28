class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :set_wallets, only: [:create]

  def create
    transaction = Transaction.new(
      amount: transaction_params[:amount],
      transaction_type: transaction_params[:transaction_type],
      source_wallet: @source_wallet,
      target_wallet: @target_wallet
    )

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def set_wallets
    begin
      @source_wallet = Wallet.find(params[:source_wallet_id])
      @target_wallet = Wallet.find(params[:target_wallet_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Wallet tidak ditemukan" }, status: :not_found and return
    end
  end

  def transaction_params
    params.permit(:amount, :transaction_type, :source_wallet_id, :target_wallet_id)
  end

  def authenticate_user
    unless current_user
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
