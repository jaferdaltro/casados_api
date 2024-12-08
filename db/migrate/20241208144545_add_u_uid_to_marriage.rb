class AddUUidToMarriage < ActiveRecord::Migration[7.2]
  def change
    add_column :marriages, :uuid, :string
  end
end
