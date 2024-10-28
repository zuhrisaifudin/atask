class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validate :validate_transaction
  validate :different_wallets

  after_create :update_wallets

  private

  def validate_transaction
    if transaction_type == 'credit'
      if target_wallet.nil?
        errors.add(:target_wallet, "Dompet tujuan tidak boleh kosong")
      elsif source_wallet.nil? || source_wallet.balance <= 0
        errors.add(:source_wallet, "Dompet sumber tidak boleh kosong atau saldo tidak tersedia untuk transaksi kredit")
      end
    elsif transaction_type == 'debit'
      if source_wallet.nil?
        errors.add(:source_wallet, "Dompet sumber tidak boleh kosong")
      elsif source_wallet.balance < amount
        errors.add(:source_wallet, "Saldo tidak tersedia")
      end
    end
  end

  def different_wallets
    if source_wallet_id == target_wallet_id
      errors.add(:base, "Dompet sumber dan dompet tujuan tidak boleh sama")
    end
  end
  

  def update_wallets
    if transaction_type == 'credit'
      target_wallet.credit(amount)
    elsif transaction_type == 'debit'
      if source_wallet.balance >= amount
        source_wallet.debit(amount) 
        target_wallet.credit(amount)
      else
        raise StandardError, "Saldo tidak tersedia untuk transaksi debit"
      end
    end
  end
  
  
end
