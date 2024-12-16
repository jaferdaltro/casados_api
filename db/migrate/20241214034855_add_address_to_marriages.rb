class AddAddressToMarriages < ActiveRecord::Migration[7.2]
  def up
    add_column :marriages, :address_id, :integer
    add_index :marriages, :address_id
  end

  def down
    remove_column :marriages, :address_id
  end
end
