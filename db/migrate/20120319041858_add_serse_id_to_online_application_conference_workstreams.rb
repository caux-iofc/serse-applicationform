class AddSerseIdToOnlineApplicationConferenceWorkstreams < ActiveRecord::Migration
  def change
    add_column :online_application_conference_workstreams, :serse_id, :integer
  end
end
