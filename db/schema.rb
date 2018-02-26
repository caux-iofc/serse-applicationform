# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180225151900) do

  create_table "address_versions", force: :cascade do |t|
    t.integer  "address_id",            limit: 4
    t.integer  "lock_version",          limit: 4
    t.integer  "online_application_id", limit: 4
    t.string   "kind",                  limit: 255
    t.string   "street1",               limit: 255
    t.string   "street2",               limit: 255
    t.string   "street3",               limit: 255
    t.string   "city",                  limit: 255
    t.string   "postal_code",           limit: 255
    t.string   "state",                 limit: 255
    t.integer  "country_id",            limit: 4
    t.string   "other_country",         limit: 255
    t.date     "valid_from"
    t.date     "valid_until"
    t.string   "created_by",            limit: 100, default: ""
    t.string   "updated_by",            limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "address_versions", ["address_id"], name: "index_address_versions_on_address_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.string   "kind",                  limit: 255
    t.string   "street1",               limit: 255
    t.string   "street2",               limit: 255
    t.string   "street3",               limit: 255
    t.string   "city",                  limit: 255
    t.string   "postal_code",           limit: 255
    t.string   "state",                 limit: 255
    t.integer  "country_id",            limit: 4
    t.string   "other_country",         limit: 255
    t.date     "valid_from"
    t.date     "valid_until"
    t.string   "created_by",            limit: 100, default: "", null: false
    t.string   "updated_by",            limit: 100, default: "", null: false
    t.integer  "lock_version",          limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id", using: :btree

  create_table "application_group_versions", force: :cascade do |t|
    t.integer  "application_group_id",       limit: 4
    t.integer  "lock_version",               limit: 4
    t.string   "name",                       limit: 255
    t.string   "session_id",                 limit: 255
    t.boolean  "complete"
    t.boolean  "confirm_read_documents"
    t.boolean  "data_protection_consent"
    t.boolean  "data_protection_caux_info"
    t.boolean  "data_protection_local_info"
    t.integer  "session_group_id",           limit: 4
    t.text     "comment",                    limit: 16777215
    t.string   "browser",                    limit: 255
    t.string   "remote_ip",                  limit: 255
    t.string   "created_by",                 limit: 100,      default: ""
    t.string   "updated_by",                 limit: 100,      default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_application_group_id", limit: 4
    t.boolean  "copied_to_serse",                             default: false
    t.boolean  "group_registration",                          default: false, null: false
    t.boolean  "family_registration",                         default: false, null: false
    t.string   "group_or_family_name",       limit: 255,      default: "",    null: false
    t.integer  "payment_required",           limit: 4,        default: 0,     null: false
    t.integer  "payment_received",           limit: 4,        default: 0,     null: false
    t.text     "payment_reference",          limit: 65535,                    null: false
    t.string   "payment_currency",           limit: 255,      default: "",    null: false
  end

  add_index "application_group_versions", ["application_group_id"], name: "index_application_group_versions_on_application_group_id", using: :btree

  create_table "application_groups", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "session_id",                 limit: 255,                      null: false
    t.boolean  "complete"
    t.boolean  "confirm_read_documents"
    t.boolean  "data_protection_consent"
    t.boolean  "data_protection_caux_info"
    t.boolean  "data_protection_local_info"
    t.integer  "session_group_id",           limit: 4
    t.text     "comment",                    limit: 16777215
    t.string   "browser",                    limit: 255
    t.string   "remote_ip",                  limit: 255
    t.string   "created_by",                 limit: 100,      default: "",    null: false
    t.string   "updated_by",                 limit: 100,      default: "",    null: false
    t.integer  "lock_version",               limit: 4,        default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "copied_to_serse",                             default: false
    t.integer  "serse_application_group_id", limit: 4
    t.boolean  "group_registration",                          default: false, null: false
    t.boolean  "family_registration",                         default: false, null: false
    t.string   "group_or_family_name",       limit: 255,      default: "",    null: false
    t.integer  "payment_required",           limit: 4,        default: 0,     null: false
    t.integer  "payment_received",           limit: 4,        default: 0,     null: false
    t.text     "payment_reference",          limit: 65535,                    null: false
    t.string   "payment_currency",           limit: 255,      default: "",    null: false
  end

  add_index "application_groups", ["session_group_id"], name: "index_application_groups_on_session_group_id", using: :btree

  create_table "application_translation_need_versions", force: :cascade do |t|
    t.integer  "application_translation_need_id", limit: 4
    t.integer  "lock_version",                    limit: 4
    t.integer  "online_application_id",           limit: 4
    t.integer  "language_id",                     limit: 4
    t.string   "created_by",                      limit: 100, default: ""
    t.string   "updated_by",                      limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "need",                                        default: false, null: false
  end

  add_index "application_translation_need_versions", ["application_translation_need_id"], name: "index_application_translation_need_versions_on_application_tran", using: :btree

  create_table "application_translation_needs", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.integer  "language_id",           limit: 4
    t.string   "created_by",            limit: 100, default: "",    null: false
    t.string   "updated_by",            limit: 100, default: "",    null: false
    t.integer  "lock_version",          limit: 4,   default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "need",                              default: false, null: false
  end

  create_table "conference_package_versions", force: :cascade do |t|
    t.integer  "conference_package_id", limit: 4
    t.integer  "lock_version",          limit: 4
    t.integer  "conference_id",         limit: 4
    t.integer  "price",                 limit: 8
    t.integer  "rate_id",               limit: 4
    t.integer  "rate_nightly",          limit: 8
    t.string   "currency",              limit: 3
    t.integer  "serse_id",              limit: 4
    t.integer  "created_by",            limit: 4
    t.integer  "updated_by",            limit: 4
    t.integer  "deleted_by",            limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_package_versions", ["conference_package_id"], name: "index_conference_package_versions_on_conference_package_id", using: :btree

  create_table "conference_packages", force: :cascade do |t|
    t.integer  "conference_id", limit: 4
    t.decimal  "price",                   precision: 10
    t.integer  "rate_id",       limit: 4
    t.decimal  "rate_nightly",            precision: 10
    t.string   "currency",      limit: 3
    t.integer  "serse_id",      limit: 4
    t.integer  "created_by",    limit: 4
    t.integer  "updated_by",    limit: 4
    t.integer  "deleted_by",    limit: 4
    t.integer  "lock_version",  limit: 4,                default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "conference_translations", force: :cascade do |t|
    t.integer  "conference_id", limit: 4
    t.string   "locale",        limit: 255
    t.string   "byline",        limit: 255
    t.string   "name",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_translations", ["conference_id"], name: "index_conference_translations_on_conference_id", using: :btree
  add_index "conference_translations", ["locale"], name: "index_conference_translations_on_locale", using: :btree

  create_table "conference_versions", force: :cascade do |t|
    t.integer  "conference_id",                  limit: 4
    t.integer  "lock_version",                   limit: 4
    t.integer  "session_group_id",               limit: 4
    t.datetime "start"
    t.datetime "stop"
    t.boolean  "private"
    t.boolean  "special"
    t.boolean  "display_dates"
    t.string   "abbreviation",                   limit: 255
    t.string   "template_path",                  limit: 255
    t.integer  "serse_id",                       limit: 4
    t.string   "created_by",                     limit: 100, default: ""
    t.string   "updated_by",                     limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full",                                       default: false, null: false
    t.boolean  "caux_forum_training",                        default: false, null: false
    t.boolean  "early_bird_discount_percentage",             default: false, null: false
    t.boolean  "internal",                                   default: false, null: false
  end

  add_index "conference_versions", ["conference_id"], name: "index_conference_versions_on_conference_id", using: :btree

  create_table "conference_workstream_translations", force: :cascade do |t|
    t.integer  "conference_workstream_id", limit: 4
    t.string   "locale",                   limit: 255
    t.string   "language",                 limit: 255
    t.string   "byline",                   limit: 255
    t.string   "name",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_workstream_translations", ["conference_workstream_id"], name: "index_ab83f95ead2bb1de6c8c949c308b2cb99df775ad", using: :btree
  add_index "conference_workstream_translations", ["locale"], name: "index_conference_workstream_translations_on_locale", using: :btree

  create_table "conference_workstream_versions", force: :cascade do |t|
    t.integer  "conference_workstream_id", limit: 4
    t.integer  "lock_version",             limit: 4
    t.integer  "conference_id",            limit: 4
    t.integer  "priority_sort",            limit: 4
    t.string   "created_by",               limit: 100, default: ""
    t.string   "updated_by",               limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_id",                 limit: 4
  end

  add_index "conference_workstream_versions", ["conference_workstream_id"], name: "index_conference_workstream_versions_on_conference_workstream_i", using: :btree

  create_table "conference_workstreams", force: :cascade do |t|
    t.integer  "conference_id", limit: 4
    t.integer  "priority_sort", limit: 4
    t.string   "created_by",    limit: 100, default: "", null: false
    t.string   "updated_by",    limit: 100, default: "", null: false
    t.integer  "lock_version",  limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_id",      limit: 4
  end

  add_index "conference_workstreams", ["conference_id"], name: "index_conference_workstreams_on_conference_id", using: :btree

  create_table "conferences", force: :cascade do |t|
    t.integer  "session_group_id",               limit: 4
    t.datetime "start"
    t.datetime "stop"
    t.boolean  "private"
    t.boolean  "special"
    t.boolean  "display_dates"
    t.string   "abbreviation",                   limit: 255
    t.string   "template_path",                  limit: 255
    t.integer  "serse_id",                       limit: 4
    t.string   "created_by",                     limit: 100, default: "",    null: false
    t.string   "updated_by",                     limit: 100, default: "",    null: false
    t.integer  "lock_version",                   limit: 4,   default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full",                                       default: false, null: false
    t.integer  "early_bird_discount_percentage", limit: 4,   default: 0,     null: false
    t.boolean  "caux_forum_training",                        default: false, null: false
    t.boolean  "internal",                                   default: false, null: false
  end

  add_index "conferences", ["session_group_id"], name: "index_conferences_on_session_group_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.integer  "zipcode_order", limit: 4
    t.integer  "state_order",   limit: 4
    t.integer  "serse_id",      limit: 4
    t.string   "created_by",    limit: 100, default: "", null: false
    t.string   "updated_by",    limit: 100, default: "", null: false
    t.integer  "lock_version",  limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_translations", force: :cascade do |t|
    t.integer  "country_id", limit: 4
    t.string   "locale",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_translations", ["country_id"], name: "index_country_translations_on_country_id", using: :btree
  add_index "country_translations", ["locale"], name: "index_country_translations_on_locale", using: :btree

  create_table "country_versions", force: :cascade do |t|
    t.integer  "country_id",    limit: 4
    t.integer  "lock_version",  limit: 4
    t.integer  "zipcode_order", limit: 4
    t.integer  "state_order",   limit: 4
    t.integer  "serse_id",      limit: 4
    t.string   "created_by",    limit: 100, default: ""
    t.string   "updated_by",    limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_versions", ["country_id"], name: "index_country_versions_on_country_id", using: :btree

  create_table "diet_translations", force: :cascade do |t|
    t.integer  "diet_id",    limit: 4
    t.string   "locale",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diet_translations", ["diet_id"], name: "index_diet_translations_on_diet_id", using: :btree
  add_index "diet_translations", ["locale"], name: "index_diet_translations_on_locale", using: :btree

  create_table "diet_versions", force: :cascade do |t|
    t.integer  "diet_id",       limit: 4
    t.integer  "lock_version",  limit: 4
    t.integer  "priority_sort", limit: 4
    t.string   "created_by",    limit: 100, default: ""
    t.string   "updated_by",    limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "menu",                      default: false, null: false
    t.string   "code",          limit: 255, default: "",    null: false
  end

  add_index "diet_versions", ["diet_id"], name: "index_diet_versions_on_diet_id", using: :btree

  create_table "diets", force: :cascade do |t|
    t.integer  "priority_sort", limit: 4
    t.string   "created_by",    limit: 100, default: "",    null: false
    t.string   "updated_by",    limit: 100, default: "",    null: false
    t.integer  "lock_version",  limit: 4,   default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "menu",                      default: false, null: false
    t.string   "code",          limit: 255, default: "",    null: false
  end

  create_table "language_translations", force: :cascade do |t|
    t.integer  "language_id", limit: 4
    t.string   "locale",      limit: 255
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_translations", ["language_id"], name: "index_language_translations_on_language_id", using: :btree
  add_index "language_translations", ["locale"], name: "index_language_translations_on_locale", using: :btree

  create_table "language_versions", force: :cascade do |t|
    t.integer  "language_id",   limit: 4
    t.integer  "lock_version",  limit: 4
    t.integer  "priority_sort", limit: 4
    t.integer  "serse_id",      limit: 4
    t.string   "created_by",    limit: 100, default: ""
    t.string   "updated_by",    limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_versions", ["language_id"], name: "index_language_versions_on_language_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.integer  "priority_sort", limit: 4
    t.integer  "serse_id",      limit: 4
    t.string   "created_by",    limit: 100, default: "", null: false
    t.string   "updated_by",    limit: 100, default: "", null: false
    t.integer  "lock_version",  limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_application_conference_versions", force: :cascade do |t|
    t.integer  "online_application_conference_id", limit: 4
    t.integer  "lock_version",                     limit: 4
    t.integer  "online_application_id",            limit: 4
    t.integer  "conference_id",                    limit: 4
    t.boolean  "selected"
    t.text     "variables",                        limit: 16777215
    t.integer  "priority_sort",                    limit: 4
    t.boolean  "role_participant"
    t.boolean  "role_speaker"
    t.boolean  "role_team"
    t.string   "created_by",                       limit: 100,      default: ""
    t.string   "updated_by",                       limit: 100,      default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "role_exhibitor",                                    default: false
  end

  add_index "online_application_conference_versions", ["online_application_conference_id"], name: "index_online_application_conference_versions_on_online_applicat", using: :btree

  create_table "online_application_conference_workstream_versions", force: :cascade do |t|
    t.integer  "online_application_conference_workstream_id", limit: 4
    t.integer  "lock_version",                                limit: 4
    t.integer  "online_application_conference_id",            limit: 4
    t.integer  "conference_workstream_id",                    limit: 4
    t.string   "preference",                                  limit: 255
    t.string   "created_by",                                  limit: 100, default: ""
    t.string   "updated_by",                                  limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_id",                                    limit: 4
  end

  add_index "online_application_conference_workstream_versions", ["online_application_conference_workstream_id"], name: "index_online_application_conference_workstream_versions_on_onli", using: :btree

  create_table "online_application_conference_workstreams", force: :cascade do |t|
    t.integer  "online_application_conference_id", limit: 4
    t.integer  "conference_workstream_id",         limit: 4
    t.string   "preference",                       limit: 255
    t.string   "created_by",                       limit: 100, default: "", null: false
    t.string   "updated_by",                       limit: 100, default: "", null: false
    t.integer  "lock_version",                     limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_id",                         limit: 4
  end

  add_index "online_application_conference_workstreams", ["conference_workstream_id"], name: "index_oa_conf_workstreams_on_conference_workstream_id", using: :btree
  add_index "online_application_conference_workstreams", ["online_application_conference_id"], name: "index_oa_conf_workstreams_on_application_id", using: :btree

  create_table "online_application_conferences", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.integer  "conference_id",         limit: 4
    t.boolean  "selected"
    t.text     "variables",             limit: 16777215
    t.integer  "priority_sort",         limit: 4
    t.boolean  "role_participant"
    t.boolean  "role_speaker"
    t.boolean  "role_team"
    t.string   "created_by",            limit: 100,      default: "",    null: false
    t.string   "updated_by",            limit: 100,      default: "",    null: false
    t.integer  "lock_version",          limit: 4,        default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "role_exhibitor",                         default: false
  end

  add_index "online_application_conferences", ["conference_id", "online_application_id"], name: "index_oa_conf_uniq", unique: true, using: :btree
  add_index "online_application_conferences", ["conference_id"], name: "index_oa_conferences_on_conference_id", using: :btree
  add_index "online_application_conferences", ["online_application_id"], name: "index_oa_conferences_on_online_application_id", using: :btree

  create_table "online_application_diet_versions", force: :cascade do |t|
    t.integer  "online_application_diet_id", limit: 4
    t.integer  "lock_version",               limit: 4
    t.integer  "online_application_id",      limit: 4
    t.integer  "diet_id",                    limit: 4
    t.string   "created_by",                 limit: 100, default: ""
    t.string   "updated_by",                 limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_diet_versions", ["online_application_diet_id"], name: "index_online_application_diet_versions_on_online_application_di", using: :btree

  create_table "online_application_diets", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.integer  "diet_id",               limit: 4
    t.string   "created_by",            limit: 100, default: "", null: false
    t.string   "updated_by",            limit: 100, default: "", null: false
    t.integer  "lock_version",          limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_diets", ["diet_id"], name: "index_online_application_diets_on_diet_id", using: :btree
  add_index "online_application_diets", ["online_application_id"], name: "index_online_application_diets_on_online_application_id", using: :btree

  create_table "online_application_language_versions", force: :cascade do |t|
    t.integer  "online_application_language_id", limit: 4
    t.integer  "lock_version",                   limit: 4
    t.integer  "online_application_id",          limit: 4
    t.integer  "language_id",                    limit: 4
    t.integer  "proficiency",                    limit: 4
    t.string   "created_by",                     limit: 100, default: ""
    t.string   "updated_by",                     limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_language_versions", ["online_application_language_id"], name: "index_online_application_language_versions_on_online_applicatio", using: :btree

  create_table "online_application_languages", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.integer  "language_id",           limit: 4
    t.integer  "proficiency",           limit: 4
    t.string   "created_by",            limit: 100, default: "", null: false
    t.string   "updated_by",            limit: 100, default: "", null: false
    t.integer  "lock_version",          limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_languages", ["language_id"], name: "index_online_application_languages_on_language_id", using: :btree
  add_index "online_application_languages", ["online_application_id"], name: "index_online_application_languages_on_online_application_id", using: :btree

  create_table "online_application_training_program_versions", force: :cascade do |t|
    t.integer  "online_application_training_program_id", limit: 4
    t.integer  "lock_version",                           limit: 4
    t.integer  "online_application_id",                  limit: 4
    t.integer  "training_program_id",                    limit: 4
    t.string   "created_by",                             limit: 100, default: ""
    t.string   "updated_by",                             limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "selected",                                           default: false, null: false
  end

  add_index "online_application_training_program_versions", ["online_application_training_program_id"], name: "index_online_application_training_program_versions_on_online_ap", using: :btree

  create_table "online_application_training_programs", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.integer  "training_program_id",   limit: 4
    t.string   "created_by",            limit: 100, default: "",    null: false
    t.string   "updated_by",            limit: 100, default: "",    null: false
    t.integer  "lock_version",          limit: 4,   default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "selected",                          default: false, null: false
  end

  add_index "online_application_training_programs", ["online_application_id"], name: "index_oa_training_programs_on_online_application_id", using: :btree
  add_index "online_application_training_programs", ["training_program_id"], name: "index_oa_training_programs_on_training_program_id", using: :btree

  create_table "online_application_versions", force: :cascade do |t|
    t.integer  "online_application_id",                  limit: 4
    t.integer  "lock_version",                           limit: 4
    t.integer  "application_group_id",                   limit: 4
    t.integer  "application_group_order",                limit: 4
    t.date     "date_of_birth"
    t.string   "relation",                               limit: 255
    t.string   "firstname",                              limit: 255
    t.string   "surname",                                limit: 255
    t.integer  "gender",                                 limit: 4
    t.integer  "citizenship_id",                         limit: 4
    t.string   "other_citizenship",                      limit: 255
    t.string   "profession",                             limit: 255
    t.string   "employer",                               limit: 255
    t.string   "email",                                  limit: 255
    t.string   "telephone",                              limit: 255
    t.string   "cellphone",                              limit: 255
    t.string   "fax",                                    limit: 255
    t.string   "work_telephone",                         limit: 255
    t.datetime "arrival"
    t.datetime "departure"
    t.string   "travel_car_train",                       limit: 255
    t.string   "travel_flight",                          limit: 255
    t.boolean  "previous_visit"
    t.string   "previous_year",                          limit: 255
    t.string   "heard_about",                            limit: 255
    t.boolean  "visa"
    t.string   "visa_reference_name",                    limit: 255
    t.string   "visa_reference_email",                   limit: 255
    t.string   "confirmation_letter_via",                limit: 255
    t.string   "accompanied_by",                         limit: 255
    t.string   "passport_number",                        limit: 255
    t.date     "passport_issue_date"
    t.string   "passport_issue_place",                   limit: 255
    t.date     "passport_expiry_date"
    t.string   "passport_embassy",                       limit: 255
    t.integer  "nightly_contribution",                   limit: 4
    t.text     "remarks",                                limit: 16777215
    t.string   "badge_firstname",                        limit: 255
    t.string   "badge_surname",                          limit: 255
    t.string   "badge_country",                          limit: 255
    t.boolean  "interpreter"
    t.boolean  "volunteer"
    t.boolean  "other_reason"
    t.string   "other_reason_detail",                    limit: 255
    t.string   "created_by",                             limit: 100,      default: ""
    t.string   "updated_by",                             limit: 100,      default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff",                                                   default: false
    t.string   "staff_detail",                           limit: 255,      default: ""
    t.string   "volunteer_detail",                       limit: 255,      default: ""
    t.string   "diet_other_detail",                      limit: 255,      default: ""
    t.boolean  "family_discount",                                         default: false
    t.boolean  "support_renovation_fund",                                 default: false
    t.boolean  "full_time_volunteer",                                     default: false
    t.boolean  "day_visit",                                               default: false
    t.integer  "calculated_registration_fee",            limit: 4,        default: 0
    t.integer  "calculated_night_rate",                  limit: 4,        default: 0
    t.integer  "calculated_total_personal_contribution", limit: 4,        default: 0
    t.boolean  "sent_by_employer",                                        default: false
    t.integer  "calculated_nights",                      limit: 4,        default: 0
    t.text     "calculated_rate_and_fee_details",        limit: 65535
    t.boolean  "student",                                                 default: false
    t.string   "status",                                 limit: 255
    t.string   "session_id",                             limit: 255
    t.string   "rate",                                   limit: 255
    t.text     "financial_remarks",                      limit: 65535
    t.integer  "communications_language_id",             limit: 4,        default: 0,     null: false
    t.integer  "translate_into_language_id",             limit: 4
  end

  add_index "online_application_versions", ["online_application_id"], name: "index_online_application_versions_on_online_application_id", using: :btree

  create_table "online_applications", force: :cascade do |t|
    t.integer  "application_group_id",                   limit: 4
    t.integer  "application_group_order",                limit: 4
    t.date     "date_of_birth"
    t.string   "relation",                               limit: 255
    t.string   "firstname",                              limit: 255
    t.string   "surname",                                limit: 255
    t.integer  "gender",                                 limit: 4
    t.integer  "citizenship_id",                         limit: 4
    t.string   "other_citizenship",                      limit: 255
    t.string   "profession",                             limit: 255
    t.string   "employer",                               limit: 255
    t.string   "email",                                  limit: 255
    t.string   "telephone",                              limit: 255
    t.string   "cellphone",                              limit: 255
    t.string   "fax",                                    limit: 255
    t.string   "work_telephone",                         limit: 255
    t.datetime "arrival"
    t.datetime "departure"
    t.string   "travel_car_train",                       limit: 255
    t.string   "travel_flight",                          limit: 255
    t.boolean  "previous_visit"
    t.string   "previous_year",                          limit: 255
    t.string   "heard_about",                            limit: 255
    t.boolean  "visa"
    t.string   "visa_reference_name",                    limit: 255
    t.string   "visa_reference_email",                   limit: 255
    t.string   "confirmation_letter_via",                limit: 255
    t.string   "accompanied_by",                         limit: 255
    t.string   "passport_number",                        limit: 255
    t.date     "passport_issue_date"
    t.string   "passport_issue_place",                   limit: 255
    t.date     "passport_expiry_date"
    t.string   "passport_embassy",                       limit: 255
    t.integer  "nightly_contribution",                   limit: 4
    t.text     "remarks",                                limit: 16777215
    t.string   "badge_firstname",                        limit: 255
    t.string   "badge_surname",                          limit: 255
    t.string   "badge_country",                          limit: 255
    t.boolean  "interpreter"
    t.boolean  "volunteer"
    t.boolean  "other_reason"
    t.string   "other_reason_detail",                    limit: 255
    t.string   "created_by",                             limit: 100,      default: "",    null: false
    t.string   "updated_by",                             limit: 100,      default: "",    null: false
    t.integer  "lock_version",                           limit: 4,        default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff",                                                   default: false
    t.string   "staff_detail",                           limit: 255,      default: ""
    t.string   "volunteer_detail",                       limit: 255,      default: ""
    t.string   "diet_other_detail",                      limit: 255,      default: ""
    t.boolean  "family_discount",                                         default: false
    t.boolean  "support_renovation_fund",                                 default: false
    t.boolean  "full_time_volunteer",                                     default: false
    t.boolean  "day_visit",                                               default: false
    t.integer  "calculated_registration_fee",            limit: 4,        default: 0
    t.integer  "calculated_night_rate",                  limit: 4,        default: 0
    t.integer  "calculated_total_personal_contribution", limit: 4,        default: 0
    t.boolean  "sent_by_employer",                                        default: false
    t.integer  "calculated_nights",                      limit: 4,        default: 0
    t.text     "calculated_rate_and_fee_details",        limit: 65535
    t.boolean  "student",                                                 default: false
    t.string   "status",                                 limit: 255
    t.string   "session_id",                             limit: 255
    t.string   "rate",                                   limit: 255
    t.text     "financial_remarks",                      limit: 65535
    t.integer  "communications_language_id",             limit: 4,        default: 0,     null: false
    t.integer  "translate_into_language_id",             limit: 4
  end

  add_index "online_applications", ["application_group_id"], name: "index_online_applications_on_application_group_id", using: :btree
  add_index "online_applications", ["citizenship_id"], name: "index_online_applications_on_citizenship_id", using: :btree

  create_table "online_form_versions", force: :cascade do |t|
    t.integer  "online_form_id",   limit: 4
    t.integer  "lock_version",     limit: 4
    t.integer  "session_group_id", limit: 4
    t.string   "abbrev",           limit: 255
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id",         limit: 4
    t.string   "created_by",       limit: 100, default: ""
    t.string   "updated_by",       limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_form_versions", ["online_form_id"], name: "index_online_form_versions_on_online_form_id", using: :btree

  create_table "online_forms", force: :cascade do |t|
    t.integer  "session_group_id", limit: 4
    t.string   "abbrev",           limit: 255
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id",         limit: 4
    t.string   "created_by",       limit: 100, default: "", null: false
    t.string   "updated_by",       limit: 100, default: "", null: false
    t.integer  "lock_version",     limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_forms", ["session_group_id"], name: "index_online_forms_on_session_group_id", using: :btree

  create_table "rate_versions", force: :cascade do |t|
    t.integer  "rate_id",                      limit: 4
    t.integer  "lock_version",                 limit: 4
    t.string   "name",                         limit: 200, default: ""
    t.integer  "from_age",                     limit: 4,   default: 0
    t.integer  "to_age",                       limit: 4,   default: 0
    t.boolean  "student",                                  default: false
    t.boolean  "maintenance",                              default: false
    t.integer  "daily_chf",                    limit: 8,   default: 0
    t.integer  "daily_eur",                    limit: 8,   default: 0
    t.integer  "daily_usd",                    limit: 8,   default: 0
    t.integer  "serse_id",                     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "created_by",                   limit: 100, default: ""
    t.string   "updated_by",                   limit: 100, default: ""
    t.boolean  "early_bird_discount_eligible",             default: false, null: false
  end

  add_index "rate_versions", ["rate_id"], name: "index_rate_versions_on_rate_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.string   "name",                         limit: 200,                default: "",    null: false
    t.integer  "from_age",                     limit: 4,                  default: 0,     null: false
    t.integer  "to_age",                       limit: 4,                  default: 0,     null: false
    t.boolean  "student",                                                 default: false, null: false
    t.boolean  "maintenance",                                             default: false, null: false
    t.decimal  "daily_chf",                                precision: 10, default: 0,     null: false
    t.decimal  "daily_eur",                                precision: 10, default: 0,     null: false
    t.decimal  "daily_usd",                                precision: 10, default: 0,     null: false
    t.integer  "serse_id",                     limit: 4
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.datetime "deleted_at"
    t.string   "created_by",                   limit: 100,                default: "",    null: false
    t.string   "updated_by",                   limit: 100,                default: "",    null: false
    t.integer  "lock_version",                 limit: 4
    t.boolean  "early_bird_discount_eligible",                            default: false, null: false
  end

  create_table "session_group_versions", force: :cascade do |t|
    t.integer  "session_group_id",       limit: 4
    t.integer  "lock_version",           limit: 4
    t.string   "name",                   limit: 255
    t.integer  "serse_id",               limit: 4
    t.string   "created_by",             limit: 100, default: ""
    t.string   "updated_by",             limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "early_bird_register_by"
  end

  add_index "session_group_versions", ["session_group_id"], name: "index_session_group_versions_on_session_group_id", using: :btree

  create_table "session_groups", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "serse_id",               limit: 4
    t.string   "created_by",             limit: 100, default: "", null: false
    t.string   "updated_by",             limit: 100, default: "", null: false
    t.integer  "lock_version",           limit: 4,   default: 0,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "early_bird_register_by"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,      null: false
    t.text     "data",       limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sponsor_versions", force: :cascade do |t|
    t.integer  "sponsor_id",            limit: 4
    t.integer  "lock_version",          limit: 4
    t.integer  "online_application_id", limit: 4
    t.string   "name",                  limit: 255
    t.integer  "nights",                limit: 4
    t.integer  "amount",                limit: 4
    t.string   "created_by",            limit: 100, default: ""
    t.string   "updated_by",            limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "auto",                              default: false, null: false
  end

  add_index "sponsor_versions", ["sponsor_id"], name: "index_sponsor_versions_on_sponsor_id", using: :btree

  create_table "sponsors", force: :cascade do |t|
    t.integer  "online_application_id", limit: 4
    t.string   "name",                  limit: 255
    t.integer  "nights",                limit: 4
    t.integer  "amount",                limit: 4
    t.string   "created_by",            limit: 100, default: "",    null: false
    t.string   "updated_by",            limit: 100, default: "",    null: false
    t.integer  "lock_version",          limit: 4,   default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "auto",                              default: false, null: false
  end

  add_index "sponsors", ["online_application_id"], name: "index_sponsors_on_online_application_id", using: :btree

  create_table "training_program_translations", force: :cascade do |t|
    t.integer  "training_program_id", limit: 4
    t.string   "locale",              limit: 255
    t.string   "byline",              limit: 255
    t.string   "name",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_program_translations", ["locale"], name: "index_training_program_translations_on_locale", using: :btree
  add_index "training_program_translations", ["training_program_id"], name: "index_3708342cad7dac9bf701cd4a10134af180c8b5f4", using: :btree

  create_table "training_program_versions", force: :cascade do |t|
    t.integer  "training_program_id", limit: 4
    t.integer  "lock_version",        limit: 4
    t.integer  "session_group_id",    limit: 4
    t.boolean  "display_dates"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id",            limit: 4
    t.string   "created_by",          limit: 100, default: ""
    t.string   "updated_by",          limit: 100, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "internal",                        default: true, null: false
  end

  add_index "training_program_versions", ["training_program_id"], name: "index_training_program_versions_on_training_program_id", using: :btree

  create_table "training_programs", force: :cascade do |t|
    t.integer  "session_group_id", limit: 4
    t.boolean  "display_dates"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id",         limit: 4
    t.string   "created_by",       limit: 100, default: "",   null: false
    t.string   "updated_by",       limit: 100, default: "",   null: false
    t.integer  "lock_version",     limit: 4,   default: 0,    null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "internal",                     default: true, null: false
  end

  add_index "training_programs", ["session_group_id"], name: "index_training_programs_on_session_group_id", using: :btree

end
