class CreateStudyPrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :study_programs do |t|
      t.string :degree, limit: 1 # B(achelor), M(aster), D(iplom)

      t.string :name_de
      t.string :name_fr
      t.string :name_en

      t.timestamps
    end
  end
end
