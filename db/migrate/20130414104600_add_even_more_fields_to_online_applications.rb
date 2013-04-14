class AddEvenMoreFieldsToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :sent_by_employer, :boolean, :default => false
  end
end
