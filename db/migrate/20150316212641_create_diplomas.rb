class CreateDiplomas < ActiveRecord::Migration[5.2]
  def change
    create_table :diplomas do |t|
      t.references :student, index: true
      t.references :study_program, index: true
      t.date :studies_start
      t.date :studies_end
      t.boolean :studies_finished
      t.string :matriculation_number

      t.timestamps
    end
  end
end
