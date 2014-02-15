class AddRoleExhibitorToOnlineApplicationConferences < ActiveRecord::Migration
  def change
    add_column :online_application_conferences, :role_exhibitor, :boolean, :default => false
  end
end
