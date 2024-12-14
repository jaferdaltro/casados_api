class AddAddressToMarriages < ActiveRecord::Migration[7.2]
  def up
    add_reference :marriages, :address, null: false, foreign_key: true
  end

  def down
    remove_reference :marriages, :address, null: false, foreign_key: true
  end
end
