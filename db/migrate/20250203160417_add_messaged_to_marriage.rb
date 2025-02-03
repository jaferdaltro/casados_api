class AddMessagedToMarriage < ActiveRecord::Migration[7.2]
  def change
    add_column :marriages, :messaged, :boolean, default: false
  end
end
