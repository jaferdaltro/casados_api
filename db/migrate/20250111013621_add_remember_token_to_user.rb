class AddRememberTokenToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :remember_token, :string
    add_column :users, :remember_digest, :string
  end
end
