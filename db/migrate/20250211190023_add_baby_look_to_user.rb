class AddBabyLookToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :baby_look, :boolean, default: false
  end
end
