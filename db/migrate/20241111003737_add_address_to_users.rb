class AddAddressToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :address, foreign_key: true
  end
end
