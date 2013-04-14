class AddEvenMoreFieldsToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :sent_by_employer, :boolean, :default => false
    add_column :online_applications, :calculated_rate_and_fee_details, :text, :default => ''
  end
end
