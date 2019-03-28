class CreateStudyProgramDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :study_program_details do |t|
      t.references :study_program, index: true

      t.string :degree, limit: 1
      t.integer :internship_duration_weeks
      t.integer :internship_start_month, limit: 2

      t.timestamps
    end
  end
end
