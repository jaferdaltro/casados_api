class AddStatusToClassrooms < ActiveRecord::Migration[7.2]
  def change
    add_column :classrooms, :active, :boolean, default: false
  end
end
