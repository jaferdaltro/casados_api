class CreateMarriages < ActiveRecord::Migration[7.2]
  def change
    create_table :marriages do |t|
      t.integer :husband_id
      t.integer :wife_id
      t.integer :address_id
      t.string :registered_by
      t.boolean :dinner_participation, default: false
      t.text :reason
      t.boolean :is_member
      t.string :campus
      t.string :religion
      t.boolean :active, default: false
      t.integer :children_quantity
      t.text :days_availability, array: true

      t.timestamps
    end
    add_index :marriages, :husband_id
    add_index :marriages, :wife_id
    add_index :marriages, :address_id
    add_index :marriages, [ :husband_id, :wife_id ], unique: true
  end
end
