class ChangeLatToAddress < ActiveRecord::Migration[7.2]
  def change
    rename_column :addresses, :lat, :latitude
    rename_column :addresses, :lng, :longitude

    add_index :addresses, [ :latitude, :longitude ]
  end
end
