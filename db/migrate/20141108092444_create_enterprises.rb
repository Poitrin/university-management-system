class CreateEnterprises < ActiveRecord::Migration[5.2]
  def change
    create_table :enterprises do |t|
      t.references :parent, index: true
      t.references :address, index: true
      t.references :director, index: true

      t.string :name
      t.string :normalized_name
      t.text :profile
      t.string :website
      # t.string :email
      # t.string :fixed_line
      # t.string :fax
      t.boolean :is_validated

      t.integer :created_by, index: true
      t.timestamps
    end

    add_index :enterprises, :name, :unique => true
  end
end