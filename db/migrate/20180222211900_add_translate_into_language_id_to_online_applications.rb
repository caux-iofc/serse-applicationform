class AddTranslateIntoLanguageIdToOnlineApplications < ActiveRecord::Migration
  def change
    add_column(:online_applications, :translate_into_language_id, :integer, { :default => nil })
    add_column(:online_application_versions, :translate_into_language_id, :integer, { :default => nil })
  end
end
