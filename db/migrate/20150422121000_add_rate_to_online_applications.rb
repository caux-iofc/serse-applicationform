class AddRateToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :rate, :string, :default => nil
  end
end
