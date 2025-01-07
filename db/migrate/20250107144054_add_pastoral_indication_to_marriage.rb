class AddPastoralIndicationToMarriage < ActiveRecord::Migration[7.2]
  def change
    add_column :marriages, :pastoral_indication, :boolean, default: false
  end
end
