class AddSemesterToClassrooms < ActiveRecord::Migration[7.2]
  def change
    add_column :classrooms, :semester, :string
  end
end
