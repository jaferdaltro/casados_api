class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :cpf, :string
    add_column :users, :gender, :string
    add_column :users, :birth_at, :date
    add_column :users, :tshirt_size, :string
  end
end
