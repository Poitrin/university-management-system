# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2015_03_16_212641) do

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "address_type"
    t.string "line1"
    t.string "line2"
    t.string "postal_code"
    t.string "city"
    t.string "country_id", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "id", limit: 2, null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_en", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_countries_on_id", unique: true
  end

  create_table "diplomas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "study_program_id"
    t.date "studies_start"
    t.date "studies_end"
    t.boolean "studies_finished"
    t.string "matriculation_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_diplomas_on_student_id"
    t.index ["study_program_id"], name: "index_diplomas_on_study_program_id"
  end

  create_table "enterprises", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "address_id"
    t.bigint "director_id"
    t.string "name"
    t.string "normalized_name"
    t.text "profile"
    t.string "website"
    t.boolean "is_validated"
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_enterprises_on_address_id"
    t.index ["created_by"], name: "index_enterprises_on_created_by"
    t.index ["director_id"], name: "index_enterprises_on_director_id"
    t.index ["name"], name: "index_enterprises_on_name", unique: true
    t.index ["parent_id"], name: "index_enterprises_on_parent_id"
  end

  create_table "internships", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "study_program_id"
    t.bigint "enterprise_id"
    t.date "start_date"
    t.date "end_date"
    t.text "project_description"
    t.boolean "project_confidential"
    t.integer "working_days_per_week"
    t.integer "working_hours_per_week"
    t.string "internship_origin"
    t.bigint "university_supervisor_id"
    t.bigint "enterprise_supervisor_id"
    t.boolean "authorized"
    t.integer "authorized_by"
    t.date "authorization_date"
    t.text "authorization_reasons"
    t.boolean "validated"
    t.integer "validated_by"
    t.date "validation_date"
    t.text "validation_reasons"
    t.float "payment_per_month"
    t.string "lang_id", limit: 2
    t.string "department"
    t.bigint "internship_address_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_internships_on_enterprise_id"
    t.index ["enterprise_supervisor_id"], name: "index_internships_on_enterprise_supervisor_id"
    t.index ["internship_address_id"], name: "index_internships_on_internship_address_id"
    t.index ["student_id"], name: "index_internships_on_student_id"
    t.index ["study_program_id"], name: "index_internships_on_study_program_id"
    t.index ["university_supervisor_id"], name: "index_internships_on_university_supervisor_id"
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "type"
    t.bigint "title_id"
    t.string "first_name"
    t.string "surname"
    t.string "birth_name"
    t.string "normalized_name"
    t.date "birth_date"
    t.bigint "address_id"
    t.string "private_email"
    t.string "private_fixed_line"
    t.string "private_cell_phone"
    t.string "business_email"
    t.string "business_fixed_line"
    t.string "business_cell_phone"
    t.string "url"
    t.string "nationality", limit: 2
    t.string "second_nationality", limit: 2
    t.string "comment"
    t.string "login"
    t.string "password_digest"
    t.boolean "administrator"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_people_on_address_id"
    t.index ["title_id"], name: "index_people_on_title_id"
    t.index ["token"], name: "index_people_on_token", unique: true
  end

  create_table "study_program_details", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "study_program_id"
    t.string "degree", limit: 1
    t.integer "internship_duration_weeks"
    t.integer "internship_start_month", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_program_id"], name: "index_study_program_details_on_study_program_id"
  end

  create_table "study_programs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "degree", limit: 1
    t.string "name_de"
    t.string "name_fr"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "title_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "title_id"
    t.string "lang_id", limit: 2
    t.string "title_short"
    t.string "title_long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title_id"], name: "index_title_translations_on_title_id"
  end

  create_table "titles", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
