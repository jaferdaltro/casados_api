class AddIsAsaasToMarriage < ActiveRecord::Migration[7.2]
  def change
    add_column :marriages, :id_asaas, :string
  end
end
