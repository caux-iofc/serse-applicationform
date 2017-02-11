class AddAnotherPaymentFieldToApplicationGroups < ActiveRecord::Migration
  def change
    add_column :application_groups, :payment_currency, :string, :default => '', :null => false
    add_column :application_group_versions, :payment_currency, :string, :default => '', :null => false
  end
end
