class AddGroupAndFamilyFieldsToApplicationGroups < ActiveRecord::Migration
  def change
    add_column :application_groups, :group_registration, :boolean, :default => false, :null => false
    add_column :application_groups, :family_registration, :boolean, :default => false, :null => false
    add_column :application_groups, :group_or_family_name, :string, :default => '', :null => false
  end
end
