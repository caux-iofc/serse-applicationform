class FixesForRails4Ter < ActiveRecord::Migration
  def change
    add_column :conference_versions, :early_bird_discount_percentage, :boolean, :default => false, :null => false
    add_column :conference_workstream_versions, :serse_id, :integer
    add_column :online_application_conference_workstream_versions, :serse_id, :integer
    add_column :rate_versions, :early_bird_discount_eligible, :boolean, :default => false, :null => false
    add_column :session_group_versions, :early_bird_register_by, :datetime

  end
end
