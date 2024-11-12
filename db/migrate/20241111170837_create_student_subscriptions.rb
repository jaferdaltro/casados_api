class CreateStudentSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :student_subscriptions do |t|
      t.integer :marriage_id
      t.integer :voucher_id, null: false

      t.timestamps
    end
  end
end
