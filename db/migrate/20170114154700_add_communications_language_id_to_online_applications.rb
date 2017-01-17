class AddCommunicationsLanguageIdToOnlineApplications < ActiveRecord::Migration
  def change
    add_column(:online_applications, :communications_language_id, :integer, { :default => '0', :null => false })
  end
end
