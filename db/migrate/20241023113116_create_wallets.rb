class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.string :type
      t.references :walletable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
