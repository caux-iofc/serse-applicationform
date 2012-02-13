class CreateOnlineApplications < ActiveRecord::Migration
  def up
    create_table :online_applications do |t|
      t.references :application_group
      t.integer :application_group_order
      t.date :date_of_birth
      t.string :relation
      t.string :firstname
      t.string :surname
      t.integer :gender
      t.integer :citizenship_id
      t.string :other_citizenship
      t.string :profession
      t.string :employer
      t.string :email
      t.string :telephone
      t.string :cellphone
      t.string :fax
      t.string :work_telephone
      t.datetime :arrival
      t.datetime :departure
      t.string :travel_car_train
      t.string :travel_flight
      t.boolean :previous_visit
      t.string :previous_year
      t.string :heard_about
      t.boolean :visa
      t.string :visa_reference_name
      t.string :visa_reference_email
      t.string :confirmation_letter_via
      t.string :accompanied_by
      t.string :passport_number
      t.date :passport_issue_date
      t.string :passport_issue_place
      t.date :passport_expiry_date
      t.string :passport_embassy
      t.integer :nightly_contribution
      t.text :remarks
      t.string :badge_firstname
      t.string :badge_surname
      t.string :badge_country
      t.string :reason_other
      t.boolean :reason_interpreting
      t.boolean :reason_volunteer

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_applications, :application_group_id
    add_index :online_applications, :citizenship_id
    OnlineApplication.create_versioned_table
  end

  def down
    drop_table :online_applications
    OnlineApplication.drop_versioned_table
  end
end
