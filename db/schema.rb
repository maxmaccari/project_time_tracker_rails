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

ActiveRecord::Schema.define(version: 20_170_125_012_343) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'friendly_id_slugs', force: :cascade do |t|
    t.string   'slug',                      null: false
    t.integer  'sluggable_id',              null: false
    t.string   'sluggable_type', limit: 50
    t.string   'scope'
    t.datetime 'created_at'
    t.index %w[slug sluggable_type scope], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope', unique: true, using: :btree
    t.index %w[slug sluggable_type], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type', using: :btree
    t.index ['sluggable_id'], name: 'index_friendly_id_slugs_on_sluggable_id', using: :btree
    t.index ['sluggable_type'], name: 'index_friendly_id_slugs_on_sluggable_type', using: :btree
  end

  create_table 'projects', force: :cascade do |t|
    t.string   'title', null: false
    t.text     'description'
    t.date     'initial_date'
    t.date     'final_date'
    t.integer  'parent_id'
    t.boolean  'active', default: true, null: false
    t.datetime 'created_at',                    null: false
    t.datetime 'updated_at',                    null: false
    t.string   'slug'
    t.integer  'estimated_time'
    t.decimal  'time_value'
    t.decimal  'project_value'
    t.index ['active'], name: 'index_projects_on_active', using: :btree
    t.index %w[parent_id title], name: 'index_projects_on_parent_id_and_title', using: :btree
    t.index ['parent_id'], name: 'index_projects_on_parent_id', using: :btree
    t.index ['slug'], name: 'index_projects_on_slug', unique: true, using: :btree
    t.index ['title'], name: 'index_projects_on_title', using: :btree
  end

  create_table 'records', force: :cascade do |t|
    t.string   'type',                     null: false
    t.date     'date',                     null: false
    t.text     'description'
    t.integer  'time',         default: 0
    t.integer  'initial_time', default: 0
    t.integer  'final_time'
    t.integer  'project_id',               null: false
    t.datetime 'created_at',               null: false
    t.datetime 'updated_at',               null: false
    t.index ['date'], name: 'index_records_on_date', using: :btree
    t.index ['project_id'], name: 'index_records_on_project_id', using: :btree
    t.index ['type'], name: 'index_records_on_type', using: :btree
  end

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  default: '', null: false
    t.string   'encrypted_password',     default: '', null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet     'current_sign_in_ip'
    t.inet     'last_sign_in_ip'
    t.datetime 'created_at',                          null: false
    t.datetime 'updated_at',                          null: false
    t.index ['email'], name: 'index_users_on_email', unique: true, using: :btree
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
  end

  add_foreign_key 'projects', 'projects', column: 'parent_id'
  add_foreign_key 'records', 'projects'
end
