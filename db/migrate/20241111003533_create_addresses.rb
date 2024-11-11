class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :number
      t.string :neighborhood
      t.string :cep
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
