class CreateClassrooms < ActiveRecord::Migration[7.2]
  def change
    create_table :classrooms do |t|
      t.references :leader_marriage, null: false, foreign_key: { to_table: :marriages }
      t.references :co_leader_marriage, null: false, foreign_key: { to_table: :marriages }

      # Address fields
      t.integer :address_id

      # Schedule fields
      t.string :weekday
      t.time :class_time

      t.timestamps
    end

    create_table :classroom_students do |t|
      t.references :classroom, null: false, foreign_key: true
      t.references :marriage, null: false, foreign_key: true
      t.timestamps
    end

    # Add index to ensure unique student assignments
    add_index :classroom_students, [ :classroom_id, :marriage_id ], unique: true

    # Add validation to limit students per classroom
    execute <<-SQL
      CREATE OR REPLACE FUNCTION check_classroom_student_limit()
      RETURNS TRIGGER AS $$
      BEGIN
        IF (SELECT COUNT(*) FROM classroom_students WHERE classroom_id = NEW.classroom_id) >= 5 THEN
          RAISE EXCEPTION 'Classroom cannot have more than 5 student couples';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER enforce_classroom_student_limit
      BEFORE INSERT ON classroom_students
      FOR EACH ROW
      EXECUTE FUNCTION check_classroom_student_limit();
    SQL
  end
end
