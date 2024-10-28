class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :transactions_as_source, class_name: 'Transaction', foreign_key: :source_wallet_id
  has_many :transactions_as_target, class_name: 'Transaction', foreign_key: :target_wallet_id

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def update_balance!(amount)
    self.balance += amount
    save!
  end

  def credit(amount)
    update_balance!(amount) if amount > 0
  end

  def debit(amount)
    if amount > 0 && balance >= amount
      update_balance!(-amount)
    else
      raise StandardError, "Saldo tidak tersedia" 
    end
  end

end
