class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :type
      t.references :title, index: true
      # TODO: gender?

      t.string :first_name
      t.string :surname
      t.string :birth_name
      t.string :normalized_name
      t.date :birth_date

      t.references :address # TODO: home, business, private (current)

      # TODO: job positions in enterprises

      t.string :private_email
      t.string :private_fixed_line
      t.string :private_cell_phone
      t.string :business_email
      t.string :business_fixed_line
      t.string :business_cell_phone
      t.string :url

      t.string :nationality, limit: 2 # = country
      t.string :second_nationality, limit: 2 # = country

      # TODO: t.boolean :valid (for deletions)
      t.string :comment

      # user:
      t.string :login
      t.string :password_digest
      t.boolean :administrator
      t.string :token
      # TODO: last login?
      # t.integer :login_attempts, default: 0
      # t.string :university_id, limit: 2
      # t.references :study_program

      t.timestamps
    end

    add_index :people, :token, unique: true
  end
end
