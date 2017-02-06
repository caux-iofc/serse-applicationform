class AddFieldsToApplicationGroupVersions < ActiveRecord::Migration
  def change
    add_column :application_group_versions, :serse_application_group_id, :integer, :default => nil
    add_column :application_group_versions, :copied_to_serse, :boolean, :default => false
    add_column :application_group_versions, :group_registration, :boolean, :default => false, :null => false
    add_column :application_group_versions, :family_registration, :boolean, :default => false, :null => false
    add_column :application_group_versions, :group_or_family_name, :string, :default => '', :null => false
    add_column :application_group_versions, :payment_required, :integer, :default => 0, :null => false
    add_column :application_group_versions, :payment_received, :integer, :default => 0, :null => false
    add_column :application_group_versions, :payment_reference, :string, :default => '', :null => false
  end
end
