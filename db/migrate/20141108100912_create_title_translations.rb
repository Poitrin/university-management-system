class CreateTitleTranslations < ActiveRecord::Migration[5.2]
  def change
    create_table :title_translations do |t|
      t.references :title, index: true
      t.string :lang_id, limit: 2
      t.string :title_short
      t.string :title_long

      t.timestamps
    end
  end
end
