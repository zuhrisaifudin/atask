class User < ApplicationRecord
    has_secure_password
    has_one :wallet, as: :walletable, dependent: :destroy
    after_create :create_wallet

    private

    def create_wallet
        self.create_wallet!(balance: 0.0) 
    end
  
    validates :email, presence: true, uniqueness: true

  end
  