class AddPaymentFieldsToApplicationGroups < ActiveRecord::Migration
  def change
    add_column :application_groups, :payment_required, :integer, :default => 0, :null => false
    add_column :application_groups, :payment_received, :integer, :default => 0, :null => false
    add_column :application_groups, :payment_reference, :string, :default => '', :null => false
  end
end
