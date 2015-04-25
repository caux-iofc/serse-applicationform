class AddFinancialRemarksToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :financial_remarks, :text, :default => ''
  end
end
