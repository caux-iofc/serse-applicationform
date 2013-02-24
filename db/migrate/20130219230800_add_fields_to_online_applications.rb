class AddFieldsToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :staff, :boolean, :default => false
    add_column :online_applications, :staff_detail, :string, :default => ''
    add_column :online_applications, :volunteer_detail, :string, :default => ''
    add_column :online_applications, :diet_other_detail, :string, :default => ''
  end
end
