class FixesForRails4Bis < ActiveRecord::Migration
  def change
    add_column :online_application_conference_versions, :role_exhibitor, :boolean, :default => false
  end
end
