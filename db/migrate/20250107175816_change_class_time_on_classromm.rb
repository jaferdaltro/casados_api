class ChangeClassTimeOnClassromm < ActiveRecord::Migration[7.2]
  def up
    change_column :classrooms, :class_time, :string
  end

  def down
    change_column :classrooms, :class_time, :time
  end
end
