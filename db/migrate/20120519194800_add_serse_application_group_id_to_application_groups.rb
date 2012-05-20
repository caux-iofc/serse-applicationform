class AddSerseApplicationGroupIdToApplicationGroups < ActiveRecord::Migration
  def change
    add_column :application_groups, :serse_application_group_id, :integer, :default => nil
  end
end
