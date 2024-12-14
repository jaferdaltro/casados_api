class AddAddressToMarriages < ActiveRecord::Migration[7.2]
  def up
    add_column :marriages, :address_id, :integer
  end

  def down
    remove_column :marriages, :address_id
  end
end
