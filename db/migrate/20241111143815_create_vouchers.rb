class CreateVouchers < ActiveRecord::Migration[7.2]
  def change
    create_table :vouchers do |t|
      t.string :code, null: false
      t.boolean :is_available, default: true
      t.datetime :expiration_at, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :vouchers, :code, unique: true
  end
end
