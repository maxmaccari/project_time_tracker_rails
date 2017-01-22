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

ActiveRecord::Schema.define(version: 20170122181751) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amount_works", force: :cascade do |t|
    t.date     "date",                    null: false
    t.text     "description"
    t.integer  "hours",       default: 0, null: false
    t.integer  "minutes",     default: 0, null: false
    t.integer  "project_id",              null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["date"], name: "index_amount_works_on_date", using: :btree
    t.index ["project_id"], name: "index_amount_works_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",                          null: false
    t.text     "description"
    t.date     "initial_date"
    t.date     "final_date"
    t.integer  "estimated_hours"
    t.decimal  "hour_value"
    t.decimal  "project_value"
    t.integer  "parent_id"
    t.boolean  "active",          default: true, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["active"], name: "index_projects_on_active", using: :btree
    t.index ["parent_id", "title"], name: "index_projects_on_parent_id_and_title", using: :btree
    t.index ["parent_id"], name: "index_projects_on_parent_id", using: :btree
    t.index ["title"], name: "index_projects_on_title", using: :btree
  end

  create_table "time_works", force: :cascade do |t|
    t.date     "date",                       null: false
    t.text     "description"
    t.integer  "initial_hour",               null: false
    t.integer  "initial_minute", default: 0, null: false
    t.integer  "final_hour"
    t.integer  "final_minute"
    t.integer  "project_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["date"], name: "index_time_works_on_date", using: :btree
    t.index ["project_id"], name: "index_time_works_on_project_id", using: :btree
  end

  add_foreign_key "amount_works", "projects"
  add_foreign_key "projects", "projects", column: "parent_id"
  add_foreign_key "time_works", "projects"
end
