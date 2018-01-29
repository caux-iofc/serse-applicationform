class FixesForRails4 < ActiveRecord::Migration
  def change
    change_column_default :application_group_versions, :payment_reference, nil
    change_column :application_group_versions, :payment_reference, :text
    add_column :sponsor_versions, :auto, :boolean, :default => false, :null => false
  end
end
