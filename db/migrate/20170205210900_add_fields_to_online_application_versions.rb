class AddFieldsToOnlineApplicationVersions < ActiveRecord::Migration
  def change
    add_column :online_application_versions, :staff, :boolean, :default => false
    add_column :online_application_versions, :staff_detail, :string, :default => ''
    add_column :online_application_versions, :volunteer_detail, :string, :default => ''
    add_column :online_application_versions, :diet_other_detail, :string, :default => ''
    add_column :online_application_versions, :family_discount, :boolean, :default => false
    add_column :online_application_versions, :support_renovation_fund, :boolean, :default => false
    add_column :online_application_versions, :full_time_volunteer, :boolean, :default => false
    add_column :online_application_versions, :day_visit, :boolean, :default => false
    add_column :online_application_versions, :calculated_registration_fee, :integer, :default => 0
    add_column :online_application_versions, :calculated_night_rate, :integer, :default => 0
    add_column :online_application_versions, :calculated_total_personal_contribution, :integer, :default => 0
    add_column :online_application_versions, :sent_by_employer, :boolean, :default => false
    add_column :online_application_versions, :calculated_nights, :integer, :default => 0
    add_column :online_application_versions, :calculated_rate_and_fee_details, :text, :default => ''
    add_column :online_application_versions, :student, :boolean, :default => false
    add_column :online_application_versions, :status, :string
    add_column :online_application_versions, :session_id, :string
    add_column :online_application_versions, :rate, :string, :default => nil
    add_column :online_application_versions, :financial_remarks, :text, :default => ''
    add_column :online_application_versions, :communications_language_id, :integer, { :default => '0', :null => false }
  end
end
