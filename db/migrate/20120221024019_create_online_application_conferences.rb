class CreateOnlineApplicationConferences < ActiveRecord::Migration
  def up
    create_table :online_application_conferences do |t|
      t.references :online_application
      t.references :conference

      # We need to build an OnlineApplicationConference object for every conference,
      # because we have conference sub forms that depend on that. So, we use a 'selected'
      # boolean to indicate if a conference was actually selected. In theory this could be 
      # done with with a virtual attribute (attr_accessor) but I had trouble setting a value
      # for the accessor in the edit method of the controller, and having the view respect
      # that value.
      t.boolean :selected

      # serialized field for custom conference variables
      t.text :variables

      t.integer :priority_sort

      t.boolean :role_participant
      t.boolean :role_speaker
      t.boolean :role_team


      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_application_conferences, :online_application_id, :name => 'index_oa_conferences_on_online_application_id'
    add_index :online_application_conferences, :conference_id, :name => 'index_oa_conferences_on_conference_id'
    OnlineApplicationConference.create_versioned_table
  end

  def down
    drop_table :online_application_conferences
    OnlineApplicationConference.drop_versioned_table
  end
end
