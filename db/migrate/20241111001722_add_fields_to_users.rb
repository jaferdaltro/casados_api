class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :cpf, :string
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :shirt_size, :string
  end
end
