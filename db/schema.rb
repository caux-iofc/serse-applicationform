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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160115205700) do

  create_table "address_versions", :force => true do |t|
    t.integer  "address_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.string   "kind"
    t.string   "street1"
    t.string   "street2"
    t.string   "street3"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.integer  "country_id"
    t.string   "other_country"
    t.date     "valid_from"
    t.date     "valid_until"
    t.string   "created_by",            :limit => 100, :default => ""
    t.string   "updated_by",            :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "address_versions", ["address_id"], :name => "index_address_versions_on_address_id"

  create_table "addresses", :force => true do |t|
    t.integer  "online_application_id"
    t.string   "kind"
    t.string   "street1"
    t.string   "street2"
    t.string   "street3"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.integer  "country_id"
    t.string   "other_country"
    t.date     "valid_from"
    t.date     "valid_until"
    t.string   "created_by",            :limit => 100, :default => "", :null => false
    t.string   "updated_by",            :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                         :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["country_id"], :name => "index_addresses_on_country_id"

  create_table "application_group_versions", :force => true do |t|
    t.integer  "application_group_id"
    t.integer  "lock_version"
    t.string   "name"
    t.string   "session_id"
    t.boolean  "complete"
    t.boolean  "data_protection_consent"
    t.boolean  "data_protection_caux_info"
    t.boolean  "data_protection_three_local_events"
    t.boolean  "data_protection_local_info"
    t.integer  "session_group_id"
    t.text     "comment"
    t.string   "browser"
    t.string   "created_by",                         :limit => 100, :default => ""
    t.string   "updated_by",                         :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_group_versions", ["application_group_id"], :name => "index_application_group_versions_on_application_group_id"

  create_table "application_groups", :force => true do |t|
    t.string   "name"
    t.string   "session_id",                                                           :null => false
    t.boolean  "complete"
    t.boolean  "data_protection_consent"
    t.boolean  "data_protection_caux_info"
    t.boolean  "data_protection_three_local_events"
    t.boolean  "data_protection_local_info"
    t.integer  "session_group_id"
    t.text     "comment"
    t.string   "browser"
    t.string   "created_by",                         :limit => 100, :default => "",    :null => false
    t.string   "updated_by",                         :limit => 100, :default => "",    :null => false
    t.integer  "lock_version",                                      :default => 0,     :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "confirm_read_documents"
    t.string   "remote_ip"
    t.boolean  "copied_to_serse",                                   :default => false
    t.integer  "serse_application_group_id"
    t.boolean  "group_registration",                                :default => false, :null => false
    t.boolean  "family_registration",                               :default => false, :null => false
    t.string   "group_or_family_name",                              :default => "",    :null => false
  end

  add_index "application_groups", ["session_group_id"], :name => "index_application_groups_on_session_group_id"

  create_table "application_translation_need_versions", :force => true do |t|
    t.integer  "application_translation_need_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.integer  "language_id"
    t.string   "created_by",                      :limit => 100, :default => ""
    t.string   "updated_by",                      :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_translation_need_versions", ["application_translation_need_id"], :name => "index_application_translation_need_versions_on_application_tran"

  create_table "application_translation_needs", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "language_id"
    t.string   "created_by",            :limit => 100, :default => "", :null => false
    t.string   "updated_by",            :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                         :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "conference_package_versions", :force => true do |t|
    t.integer  "conference_package_id"
    t.integer  "lock_version"
    t.integer  "conference_id"
    t.integer  "price",                 :limit => 8
    t.integer  "rate_id"
    t.integer  "rate_nightly",          :limit => 8
    t.string   "currency",              :limit => 3
    t.integer  "serse_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "deleted_by"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_package_versions", ["conference_package_id"], :name => "index_conference_package_versions_on_conference_package_id"

  create_table "conference_packages", :force => true do |t|
    t.integer  "conference_id"
    t.decimal  "price",                      :precision => 10, :scale => 0
    t.integer  "rate_id"
    t.decimal  "rate_nightly",               :precision => 10, :scale => 0
    t.string   "currency",      :limit => 3
    t.integer  "serse_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "deleted_by"
    t.integer  "lock_version",                                              :default => 0, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  create_table "conference_translations", :force => true do |t|
    t.integer  "conference_id"
    t.string   "locale"
    t.string   "byline"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_translations", ["conference_id"], :name => "index_conference_translations_on_conference_id"
  add_index "conference_translations", ["locale"], :name => "index_conference_translations_on_locale"

  create_table "conference_versions", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "lock_version"
    t.integer  "session_group_id"
    t.datetime "start"
    t.datetime "stop"
    t.boolean  "private"
    t.boolean  "special"
    t.boolean  "display_dates"
    t.string   "abbreviation"
    t.string   "template_path"
    t.integer  "serse_id"
    t.string   "created_by",       :limit => 100, :default => ""
    t.string   "updated_by",       :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full",                            :default => false, :null => false
  end

  add_index "conference_versions", ["conference_id"], :name => "index_conference_versions_on_conference_id"

  create_table "conference_workstream_translations", :force => true do |t|
    t.integer  "conference_workstream_id"
    t.string   "locale"
    t.string   "language"
    t.string   "name"
    t.string   "byline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_workstream_translations", ["conference_workstream_id"], :name => "index_ab83f95ead2bb1de6c8c949c308b2cb99df775ad"
  add_index "conference_workstream_translations", ["locale"], :name => "index_conference_workstream_translations_on_locale"

  create_table "conference_workstream_versions", :force => true do |t|
    t.integer  "conference_workstream_id"
    t.integer  "lock_version"
    t.integer  "conference_id"
    t.integer  "priority_sort"
    t.string   "created_by",               :limit => 100, :default => ""
    t.string   "updated_by",               :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_workstream_versions", ["conference_workstream_id"], :name => "index_conference_workstream_versions_on_conference_workstream_i"

  create_table "conference_workstreams", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "priority_sort"
    t.string   "created_by",    :limit => 100, :default => "", :null => false
    t.string   "updated_by",    :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                 :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_id"
  end

  add_index "conference_workstreams", ["conference_id"], :name => "index_conference_workstreams_on_conference_id"

  create_table "conferences", :force => true do |t|
    t.integer  "session_group_id"
    t.datetime "start"
    t.datetime "stop"
    t.boolean  "private"
    t.boolean  "special"
    t.boolean  "display_dates"
    t.string   "abbreviation"
    t.string   "template_path"
    t.integer  "serse_id"
    t.string   "created_by",                     :limit => 100, :default => "",    :null => false
    t.string   "updated_by",                     :limit => 100, :default => "",    :null => false
    t.integer  "lock_version",                                  :default => 0,     :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full",                                          :default => false, :null => false
    t.integer  "early_bird_discount_percentage",                :default => 0,     :null => false
  end

  add_index "conferences", ["session_group_id"], :name => "index_conferences_on_session_group_id"

  create_table "countries", :force => true do |t|
    t.integer  "zipcode_order"
    t.integer  "state_order"
    t.integer  "serse_id"
    t.string   "created_by",    :limit => 100, :default => "", :null => false
    t.string   "updated_by",    :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                 :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_translations", :force => true do |t|
    t.integer  "country_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_translations", ["country_id"], :name => "index_country_translations_on_country_id"
  add_index "country_translations", ["locale"], :name => "index_country_translations_on_locale"

  create_table "country_versions", :force => true do |t|
    t.integer  "country_id"
    t.integer  "lock_version"
    t.integer  "zipcode_order"
    t.integer  "state_order"
    t.integer  "serse_id"
    t.string   "created_by",    :limit => 100, :default => ""
    t.string   "updated_by",    :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_versions", ["country_id"], :name => "index_country_versions_on_country_id"

  create_table "diet_translations", :force => true do |t|
    t.integer  "diet_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diet_translations", ["diet_id"], :name => "index_diet_translations_on_diet_id"
  add_index "diet_translations", ["locale"], :name => "index_diet_translations_on_locale"

  create_table "diet_versions", :force => true do |t|
    t.integer  "diet_id"
    t.integer  "lock_version"
    t.integer  "priority_sort"
    t.string   "created_by",    :limit => 100, :default => ""
    t.string   "updated_by",    :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diet_versions", ["diet_id"], :name => "index_diet_versions_on_diet_id"

  create_table "diets", :force => true do |t|
    t.integer  "priority_sort"
    t.string   "created_by",    :limit => 100, :default => "", :null => false
    t.string   "updated_by",    :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                 :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "language_translations", :force => true do |t|
    t.integer  "language_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_translations", ["language_id"], :name => "index_language_translations_on_language_id"
  add_index "language_translations", ["locale"], :name => "index_language_translations_on_locale"

  create_table "language_versions", :force => true do |t|
    t.integer  "language_id"
    t.integer  "lock_version"
    t.integer  "priority_sort"
    t.integer  "serse_id"
    t.string   "created_by",    :limit => 100, :default => ""
    t.string   "updated_by",    :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_versions", ["language_id"], :name => "index_language_versions_on_language_id"

  create_table "languages", :force => true do |t|
    t.integer  "priority_sort"
    t.integer  "serse_id"
    t.string   "created_by",    :limit => 100, :default => "", :null => false
    t.string   "updated_by",    :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                 :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_application_conference_versions", :force => true do |t|
    t.integer  "online_application_conference_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.integer  "conference_id"
    t.boolean  "selected"
    t.text     "variables"
    t.integer  "priority_sort"
    t.boolean  "role_participant"
    t.boolean  "role_speaker"
    t.boolean  "role_team"
    t.string   "created_by",                       :limit => 100, :default => ""
    t.string   "updated_by",                       :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_conference_versions", ["online_application_conference_id"], :name => "index_online_application_conference_versions_on_online_applicat"

  create_table "online_application_conference_workstream_versions", :force => true do |t|
    t.integer  "online_application_conference_workstream_id"
    t.integer  "lock_version"
    t.integer  "online_application_conference_id"
    t.integer  "conference_workstream_id"
    t.string   "preference"
    t.string   "created_by",                                  :limit => 100, :default => ""
    t.string   "updated_by",                                  :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_conference_workstream_versions", ["online_application_conference_workstream_id"], :name => "index_online_application_conference_workstream_versions_on_onli"

  create_table "online_application_conference_workstreams", :force => true do |t|
    t.integer  "online_application_conference_id"
    t.integer  "conference_workstream_id"
    t.string   "preference"
    t.string   "created_by",                       :limit => 100, :default => "", :null => false
    t.string   "updated_by",                       :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                                    :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serse_id"
  end

  add_index "online_application_conference_workstreams", ["conference_workstream_id"], :name => "index_oa_conf_workstreams_on_conference_workstream_id"
  add_index "online_application_conference_workstreams", ["online_application_conference_id"], :name => "index_oa_conf_workstreams_on_application_id"

  create_table "online_application_conferences", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "conference_id"
    t.boolean  "selected"
    t.text     "variables"
    t.integer  "priority_sort"
    t.boolean  "role_participant"
    t.boolean  "role_speaker"
    t.boolean  "role_team"
    t.string   "created_by",            :limit => 100, :default => "",    :null => false
    t.string   "updated_by",            :limit => 100, :default => "",    :null => false
    t.integer  "lock_version",                         :default => 0,     :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "role_exhibitor",                       :default => false
  end

  add_index "online_application_conferences", ["conference_id", "online_application_id"], :name => "index_oa_conf_uniq", :unique => true
  add_index "online_application_conferences", ["conference_id"], :name => "index_oa_conferences_on_conference_id"
  add_index "online_application_conferences", ["online_application_id"], :name => "index_oa_conferences_on_online_application_id"

  create_table "online_application_diet_versions", :force => true do |t|
    t.integer  "online_application_diet_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.integer  "diet_id"
    t.string   "created_by",                 :limit => 100, :default => ""
    t.string   "updated_by",                 :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_diet_versions", ["online_application_diet_id"], :name => "index_online_application_diet_versions_on_online_application_di"

  create_table "online_application_diets", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "diet_id"
    t.string   "created_by",            :limit => 100, :default => "", :null => false
    t.string   "updated_by",            :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                         :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_diets", ["diet_id"], :name => "index_online_application_diets_on_diet_id"
  add_index "online_application_diets", ["online_application_id"], :name => "index_online_application_diets_on_online_application_id"

  create_table "online_application_language_versions", :force => true do |t|
    t.integer  "online_application_language_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.integer  "language_id"
    t.integer  "proficiency"
    t.string   "created_by",                     :limit => 100, :default => ""
    t.string   "updated_by",                     :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_language_versions", ["online_application_language_id"], :name => "index_online_application_language_versions_on_online_applicatio"

  create_table "online_application_languages", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "language_id"
    t.integer  "proficiency"
    t.string   "created_by",            :limit => 100, :default => "", :null => false
    t.string   "updated_by",            :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                         :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_languages", ["language_id"], :name => "index_online_application_languages_on_language_id"
  add_index "online_application_languages", ["online_application_id"], :name => "index_online_application_languages_on_online_application_id"

  create_table "online_application_training_program_versions", :force => true do |t|
    t.integer  "online_application_training_program_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.integer  "training_program_id"
    t.string   "created_by",                             :limit => 100, :default => ""
    t.string   "updated_by",                             :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_training_program_versions", ["online_application_training_program_id"], :name => "index_online_application_training_program_versions_on_online_ap"

  create_table "online_application_training_programs", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "training_program_id"
    t.string   "created_by",            :limit => 100, :default => "", :null => false
    t.string   "updated_by",            :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                         :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_training_programs", ["online_application_id"], :name => "index_oa_training_programs_on_online_application_id"
  add_index "online_application_training_programs", ["training_program_id"], :name => "index_oa_training_programs_on_training_program_id"

  create_table "online_application_versions", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "lock_version"
    t.integer  "application_group_id"
    t.integer  "application_group_order"
    t.date     "date_of_birth"
    t.string   "relation"
    t.string   "firstname"
    t.string   "surname"
    t.integer  "gender"
    t.integer  "citizenship_id"
    t.string   "other_citizenship"
    t.string   "profession"
    t.string   "employer"
    t.string   "email"
    t.string   "telephone"
    t.string   "cellphone"
    t.string   "fax"
    t.string   "work_telephone"
    t.datetime "arrival"
    t.datetime "departure"
    t.string   "travel_car_train"
    t.string   "travel_flight"
    t.boolean  "previous_visit"
    t.string   "previous_year"
    t.string   "heard_about"
    t.boolean  "visa"
    t.string   "visa_reference_name"
    t.string   "visa_reference_email"
    t.string   "confirmation_letter_via"
    t.string   "accompanied_by"
    t.string   "passport_number"
    t.date     "passport_issue_date"
    t.string   "passport_issue_place"
    t.date     "passport_expiry_date"
    t.string   "passport_embassy"
    t.integer  "nightly_contribution"
    t.text     "remarks"
    t.string   "badge_firstname"
    t.string   "badge_surname"
    t.string   "badge_country"
    t.boolean  "interpreter"
    t.boolean  "volunteer"
    t.boolean  "other_reason"
    t.string   "other_reason_detail"
    t.string   "created_by",              :limit => 100, :default => ""
    t.string   "updated_by",              :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_application_versions", ["online_application_id"], :name => "index_online_application_versions_on_online_application_id"

  create_table "online_applications", :force => true do |t|
    t.integer  "application_group_id"
    t.integer  "application_group_order"
    t.date     "date_of_birth"
    t.string   "relation"
    t.string   "firstname"
    t.string   "surname"
    t.integer  "gender"
    t.integer  "citizenship_id"
    t.string   "other_citizenship"
    t.string   "profession"
    t.string   "employer"
    t.string   "email"
    t.string   "telephone"
    t.string   "cellphone"
    t.string   "fax"
    t.string   "work_telephone"
    t.datetime "arrival"
    t.datetime "departure"
    t.string   "travel_car_train"
    t.string   "travel_flight"
    t.boolean  "previous_visit"
    t.string   "previous_year"
    t.string   "heard_about"
    t.boolean  "visa"
    t.string   "visa_reference_name"
    t.string   "visa_reference_email"
    t.string   "confirmation_letter_via"
    t.string   "accompanied_by"
    t.string   "passport_number"
    t.date     "passport_issue_date"
    t.string   "passport_issue_place"
    t.date     "passport_expiry_date"
    t.string   "passport_embassy"
    t.integer  "nightly_contribution"
    t.text     "remarks"
    t.string   "badge_firstname"
    t.string   "badge_surname"
    t.string   "badge_country"
    t.boolean  "interpreter"
    t.boolean  "volunteer"
    t.boolean  "other_reason"
    t.string   "other_reason_detail"
    t.string   "created_by",                             :limit => 100, :default => "",    :null => false
    t.string   "updated_by",                             :limit => 100, :default => "",    :null => false
    t.integer  "lock_version",                                          :default => 0,     :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff",                                                 :default => false
    t.string   "staff_detail",                                          :default => ""
    t.string   "volunteer_detail",                                      :default => ""
    t.string   "diet_other_detail",                                     :default => ""
    t.boolean  "family_discount",                                       :default => false
    t.boolean  "support_renovation_fund",                               :default => false
    t.boolean  "full_time_volunteer",                                   :default => false
    t.boolean  "day_visit",                                             :default => false
    t.integer  "calculated_registration_fee",                           :default => 0
    t.integer  "calculated_night_rate",                                 :default => 0
    t.integer  "calculated_total_personal_contribution",                :default => 0
    t.boolean  "sent_by_employer",                                      :default => false
    t.integer  "calculated_nights",                                     :default => 0
    t.text     "calculated_rate_and_fee_details"
    t.boolean  "student",                                               :default => false
    t.string   "status"
    t.string   "session_id"
    t.string   "rate"
    t.text     "financial_remarks"
  end

  add_index "online_applications", ["application_group_id"], :name => "index_online_applications_on_application_group_id"
  add_index "online_applications", ["citizenship_id"], :name => "index_online_applications_on_citizenship_id"

  create_table "online_form_versions", :force => true do |t|
    t.integer  "online_form_id"
    t.integer  "lock_version"
    t.integer  "session_group_id"
    t.string   "abbrev"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id"
    t.string   "created_by",       :limit => 100, :default => ""
    t.string   "updated_by",       :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_form_versions", ["online_form_id"], :name => "index_online_form_versions_on_online_form_id"

  create_table "online_forms", :force => true do |t|
    t.integer  "session_group_id"
    t.string   "abbrev"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id"
    t.string   "created_by",       :limit => 100, :default => "", :null => false
    t.string   "updated_by",       :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                    :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_forms", ["session_group_id"], :name => "index_online_forms_on_session_group_id"

  create_table "rate_versions", :force => true do |t|
    t.integer  "rate_id"
    t.integer  "lock_version"
    t.string   "name",         :limit => 200, :default => ""
    t.integer  "from_age",                    :default => 0
    t.integer  "to_age",                      :default => 0
    t.boolean  "student",                     :default => false
    t.boolean  "maintenance",                 :default => false
    t.integer  "daily_chf",    :limit => 8,   :default => 0
    t.integer  "daily_eur",    :limit => 8,   :default => 0
    t.integer  "daily_usd",    :limit => 8,   :default => 0
    t.integer  "serse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "created_by",   :limit => 100, :default => ""
    t.string   "updated_by",   :limit => 100, :default => ""
  end

  add_index "rate_versions", ["rate_id"], :name => "index_rate_versions_on_rate_id"

  create_table "rates", :force => true do |t|
    t.string   "name",                         :limit => 200,                                :default => "",    :null => false
    t.integer  "from_age",                                                                   :default => 0,     :null => false
    t.integer  "to_age",                                                                     :default => 0,     :null => false
    t.boolean  "student",                                                                    :default => false, :null => false
    t.boolean  "maintenance",                                                                :default => false, :null => false
    t.decimal  "daily_chf",                                   :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "daily_eur",                                   :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "daily_usd",                                   :precision => 10, :scale => 0, :default => 0,     :null => false
    t.integer  "serse_id"
    t.datetime "created_at",                                                                                    :null => false
    t.datetime "updated_at",                                                                                    :null => false
    t.datetime "deleted_at"
    t.string   "created_by",                   :limit => 100,                                :default => "",    :null => false
    t.string   "updated_by",                   :limit => 100,                                :default => "",    :null => false
    t.integer  "lock_version"
    t.boolean  "early_bird_discount_eligible",                                               :default => false, :null => false
  end

  create_table "session_group_versions", :force => true do |t|
    t.integer  "session_group_id"
    t.integer  "lock_version"
    t.string   "name"
    t.integer  "serse_id"
    t.string   "created_by",       :limit => 100, :default => ""
    t.string   "updated_by",       :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session_group_versions", ["session_group_id"], :name => "index_session_group_versions_on_session_group_id"

  create_table "session_groups", :force => true do |t|
    t.string   "name"
    t.integer  "serse_id"
    t.string   "created_by",             :limit => 100, :default => "", :null => false
    t.string   "updated_by",             :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                          :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "early_bird_register_by"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sponsor_versions", :force => true do |t|
    t.integer  "sponsor_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.string   "name"
    t.integer  "nights"
    t.integer  "amount"
    t.string   "created_by",            :limit => 100, :default => ""
    t.string   "updated_by",            :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsor_versions", ["sponsor_id"], :name => "index_sponsor_versions_on_sponsor_id"

  create_table "sponsors", :force => true do |t|
    t.integer  "online_application_id"
    t.string   "name"
    t.integer  "nights"
    t.integer  "amount"
    t.string   "created_by",            :limit => 100, :default => "",    :null => false
    t.string   "updated_by",            :limit => 100, :default => "",    :null => false
    t.integer  "lock_version",                         :default => 0,     :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "auto",                                 :default => false, :null => false
  end

  add_index "sponsors", ["online_application_id"], :name => "index_sponsors_on_online_application_id"

  create_table "training_program_translations", :force => true do |t|
    t.integer  "training_program_id"
    t.string   "locale"
    t.string   "byline"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_program_translations", ["locale"], :name => "index_training_program_translations_on_locale"
  add_index "training_program_translations", ["training_program_id"], :name => "index_3708342cad7dac9bf701cd4a10134af180c8b5f4"

  create_table "training_program_versions", :force => true do |t|
    t.integer  "training_program_id"
    t.integer  "lock_version"
    t.integer  "session_group_id"
    t.boolean  "display_dates"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id"
    t.string   "created_by",          :limit => 100, :default => ""
    t.string   "updated_by",          :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_program_versions", ["training_program_id"], :name => "index_training_program_versions_on_training_program_id"

  create_table "training_programs", :force => true do |t|
    t.integer  "session_group_id"
    t.boolean  "display_dates"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "serse_id"
    t.string   "created_by",       :limit => 100, :default => "", :null => false
    t.string   "updated_by",       :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                    :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_programs", ["session_group_id"], :name => "index_training_programs_on_session_group_id"

end
