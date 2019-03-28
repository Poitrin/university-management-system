class CreateInternships < ActiveRecord::Migration[5.2]
  def change
    create_table :internships do |t|
      t.references :student, index: true
      t.references :study_program, index: true
      t.references :enterprise, index: true

      t.date :start_date
      t.date :end_date
      t.text :project_description
      t.boolean :project_confidential
      t.integer :working_days_per_week
      t.integer :working_hours_per_week
      t.string :internship_origin

      t.references :university_supervisor, index: true
      t.references :enterprise_supervisor, index: true

      t.boolean :authorized
      t.integer :authorized_by
      t.date :authorization_date
      t.text :authorization_reasons

      t.boolean :validated
      t.integer :validated_by
      t.date :validation_date
      t.text :validation_reasons

      t.float :payment_per_month
      t.string :lang_id, limit: 2
      t.string :department
      t.references :internship_address, index: true

      t.text :notes

      t.timestamps
    end
  end
end
