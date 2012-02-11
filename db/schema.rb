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

ActiveRecord::Schema.define(:version => 20120208211929) do

  create_table "address_versions", :force => true do |t|
    t.integer  "address_id"
    t.integer  "lock_version"
    t.integer  "online_application_id"
    t.string   "street1"
    t.string   "street2"
    t.string   "street3"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.integer  "country_id"
    t.string   "other_country"
    t.string   "created_by",            :limit => 100, :default => ""
    t.string   "updated_by",            :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "versioned_type"
  end

  add_index "address_versions", ["address_id"], :name => "index_address_versions_on_address_id"

  create_table "addresses", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "type"
    t.string   "street1"
    t.string   "street2"
    t.string   "street3"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.integer  "country_id"
    t.string   "other_country"
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
    t.boolean  "complete"
    t.boolean  "data_protection_consent"
    t.boolean  "data_protection_caux_info"
    t.boolean  "data_protection_three_local_events"
    t.boolean  "data_protection_local_info"
    t.integer  "session_group_id"
    t.text     "comment"
    t.string   "browser"
    t.string   "created_by",                         :limit => 100, :default => "", :null => false
    t.string   "updated_by",                         :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                                      :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_groups", ["session_group_id"], :name => "index_application_groups_on_session_group_id"

  create_table "countries", :force => true do |t|
    t.integer  "zipcode_order"
    t.integer  "state_order"
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
    t.string   "created_by",    :limit => 100, :default => ""
    t.string   "updated_by",    :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_versions", ["country_id"], :name => "index_country_versions_on_country_id"

  create_table "language_versions", :force => true do |t|
    t.integer  "language_id"
    t.integer  "lock_version"
    t.string   "name"
    t.integer  "priority_sort"
    t.string   "created_by",    :limit => 100, :default => ""
    t.string   "updated_by",    :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_versions", ["language_id"], :name => "index_language_versions_on_language_id"

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.integer  "priority_sort"
    t.string   "created_by",    :limit => 100, :default => "", :null => false
    t.string   "updated_by",    :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                 :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_application_versions", :force => true do |t|
    t.integer  "online_application_id"
    t.integer  "lock_version"
    t.integer  "application_group_id"
    t.integer  "application_group_order"
    t.date     "date_of_birth"
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
    t.string   "diet"
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
    t.string   "reason_other"
    t.boolean  "reason_interpreting"
    t.boolean  "reason_volunteer"
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
    t.string   "diet"
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
    t.string   "reason_other"
    t.boolean  "reason_interpreting"
    t.boolean  "reason_volunteer"
    t.string   "created_by",              :limit => 100, :default => "", :null => false
    t.string   "updated_by",              :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                           :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "created_by",       :limit => 100, :default => "", :null => false
    t.string   "updated_by",       :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                    :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_forms", ["session_group_id"], :name => "index_online_forms_on_session_group_id"

  create_table "session_group_versions", :force => true do |t|
    t.integer  "session_group_id"
    t.integer  "lock_version"
    t.string   "name"
    t.string   "created_by",       :limit => 100, :default => ""
    t.string   "updated_by",       :limit => 100, :default => ""
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session_group_versions", ["session_group_id"], :name => "index_session_group_versions_on_session_group_id"

  create_table "session_groups", :force => true do |t|
    t.string   "name"
    t.string   "created_by",   :limit => 100, :default => "", :null => false
    t.string   "updated_by",   :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "created_by",            :limit => 100, :default => "", :null => false
    t.string   "updated_by",            :limit => 100, :default => "", :null => false
    t.integer  "lock_version",                         :default => 0,  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsors", ["online_application_id"], :name => "index_sponsors_on_online_application_id"

end
