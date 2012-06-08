class AddSerseIdToConferenceWorkstreams < ActiveRecord::Migration
  def change
    add_column :conference_workstreams, :serse_id, :integer
  end
end
