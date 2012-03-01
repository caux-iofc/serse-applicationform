class CreateSessionGroups < ActiveRecord::Migration
  def up
    create_table :session_groups do |t|
      t.string :name
      t.integer :serse_id

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    SessionGroup.create_versioned_table
  end

  def down
    SessionGroup.drop_versioned_table
    drop_table :session_groups
  end
end
