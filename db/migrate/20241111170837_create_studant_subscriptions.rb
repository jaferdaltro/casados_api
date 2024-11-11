class CreateStudantSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :studant_subscriptions do |t|
      t.integer :marriage_id
      t.integer :voucher_id, null: false

      t.timestamps
    end
  end
end
