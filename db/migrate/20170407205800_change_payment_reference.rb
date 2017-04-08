class ChangePaymentReference < ActiveRecord::Migration
  def change
    change_column :application_groups, :payment_reference, :text
  end
end
