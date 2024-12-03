class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone, null: false, index: { unique: true }
      t.string :cpf
      t.string :email
      t.date :birth_at
      t.integer :role, default: 0
      t.string :gender
      t.boolean :is_member
      t.string :campus
      t.string :religion
      t.string :t_shirt_size
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
