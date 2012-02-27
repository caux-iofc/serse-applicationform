class CreateOnlineApplicationConferenceWorkstreams < ActiveRecord::Migration
  def up
    create_table :online_application_conference_workstreams do |t|
      t.references :online_application_conference
      t.references :conference_workstream
      t.string :preference

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_application_conference_workstreams, :online_application_conference_id, :name => 'index_oa_conf_workstreams_on_application_id'
    add_index :online_application_conference_workstreams, :conference_workstream_id, :name => 'index_oa_conf_workstreams_on_conference_workstream_id'
    OnlineApplicationConferenceWorkstream.create_versioned_table
  end

  def down
    drop_table :online_application_conference_workstreams
    OnlineApplicationConferenceWorkstream.drop_versioned_table
  end
end
