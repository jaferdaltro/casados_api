class AddFieldsToMarriages < ActiveRecord::Migration[7.2]
  def change
    add_column :marriages, :active, :boolean, default: false
    add_column :marriages, :religion, :string
    add_column :marriages, :children_quantity, :integer
    add_column :marriages, :days_availability, :text, array: true
  end
end
