class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :marriage, null: false, foreign_key: true
      t.string :asaas_client_id
      t.string :description
      t.decimal :amount
      t.integer :payment_method
      t.integer :status
      t.date :due_date
      t.string :asaas_payment_id
      t.string :qr_code
      t.string :card_holder_name
      t.string :card_number
      t.string :card_expiry_month
      t.string :card_expiry_year
      t.string :card_cvv

      t.timestamps
    end
  end
end
