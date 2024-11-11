class DropAccountTable < ActiveRecord::Migration[7.2]
  def change
    remove_column :memberships, :account_id
    drop_table :accounts
  end
end
