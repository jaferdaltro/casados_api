class AddRoleToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :string, default: 'student'
    drop_table :memberships
  end
end
