class AddUuiToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :uuid, :string
  end
end
