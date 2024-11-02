class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone, null: false, index: { unique: true }
      t.string :email
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
