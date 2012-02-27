class CreateConferenceWorkstreams < ActiveRecord::Migration
  def up
    create_table :conference_workstreams do |t|
      t.references :conference
      t.integer :priority_sort

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :conference_workstreams, :conference_id
    ConferenceWorkstream.create_versioned_table
    # See Globalize3: https://github.com/svenfuchs/globalize3
    ConferenceWorkstream.create_translation_table! :name => :string, :byline => :string, :language => :string
  end

  def down
    drop_table :conference_workstreams
    ConferenceWorkstream.drop_versioned_table
    ConferenceWorkstream.drop_translation_table!
  end
end
