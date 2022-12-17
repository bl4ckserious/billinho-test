ActiveRecord::Schema[7.0].define(version: 2022_12_16_135307) do
  enable_extension "plpgsql"

  create_table "billings", force: :cascade do |t|
    t.integer "enrollment_id"
    t.float "amount"
    t.date "due_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "student_id"
    t.integer "institution_id"
    t.integer "amount"
    t.integer "installments"
    t.integer "due_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.date "birth_date"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "enrollments", "institutions"
  add_foreign_key "enrollments", "students"
  add_foreign_key "billings", "enrollments"
end
