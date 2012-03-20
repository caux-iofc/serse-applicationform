class AddCopiedToSerseToApplicationGroups < ActiveRecord::Migration
  def change
    add_column :application_groups, :copied_to_serse, :boolean, :default => false
  end
end
