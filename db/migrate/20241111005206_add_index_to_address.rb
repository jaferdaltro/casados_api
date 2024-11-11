class AddIndexToAddress < ActiveRecord::Migration[7.2]
  def change
    add_index :addresses, :street
    add_index :addresses, :neighborhood
  end
end
