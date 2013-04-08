class AddMoreFieldsToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :family_discount, :boolean, :default => false
    add_column :online_applications, :support_renovation_fund, :boolean, :default => false
    add_column :online_applications, :full_time_volunteer, :boolean, :default => false
    add_column :online_applications, :day_visit, :boolean, :default => false
    add_column :online_applications, :calculated_registration_fee, :integer, :default => 0
    add_column :online_applications, :calculated_night_rate, :integer, :default => 0
    add_column :online_applications, :calculated_total_personal_contribution, :integer, :default => 0
  end
end
