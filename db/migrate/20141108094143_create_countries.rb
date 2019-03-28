class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries, id: false do |t|
      t.string :id, limit: 2, null: false

      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_en, null: false

      t.timestamps
    end

    add_index :countries, :id, unique: true
  end
end
