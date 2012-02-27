class CreateConferences < ActiveRecord::Migration
  def up
    create_table :conferences do |t|
      t.references :session_group
      t.datetime :start
      t.datetime :stop
      t.boolean :private
      t.boolean :special
      t.string :template_path

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :conferences, :session_group_id
    Conference.create_versioned_table
    # See Globalize3: https://github.com/svenfuchs/globalize3
    Conference.create_translation_table! :name => :string, :byline => :string
  end

  def down
    drop_table :conferences
    Conference.drop_versioned_table
    Conference.drop_translation_table!
  end
end
