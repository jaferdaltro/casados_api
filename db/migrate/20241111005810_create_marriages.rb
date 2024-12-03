class CreateMarriages < ActiveRecord::Migration[7.2]
  def change
    create_table :marriages do |t|
      t.integer :husband_id
      t.integer :wife_id
      t.string :registered_by
      t.text :reason
      t.boolean :active, default: false
      t.integer :children_quantity
      t.text :days_availability, array: true

      t.timestamps
    end
    add_index :marriages, :husband_id
    add_index :marriages, :wife_id
    add_index :marriages, [ :husband_id, :wife_id ], unique: true
  end
end
