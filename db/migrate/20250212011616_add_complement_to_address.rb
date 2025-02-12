class AddComplementToAddress < ActiveRecord::Migration[7.2]
  def change
    add_column :addresses, :complement, :string
  end
end
