class ChangeCoLeaderOnClassrooms < ActiveRecord::Migration[7.2]
  def change
    remove_column :classrooms, :co_leader_marriage_id
    add_column :classrooms, :co_leader_marriage_id, :integer
  end
end
