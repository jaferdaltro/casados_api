class ChangeRoleInUser < ActiveRecord::Migration[7.2]
  def up
    change_column :users, :gender, 'integer USING CAST(gender AS integer)'
  end

  def down
    change_column :users, :gender, 'string USING CAST(gender AS text)'
  end
end
