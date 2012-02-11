class CreateSessionGroups < ActiveRecord::Migration
  def up
    create_table :session_groups do |t|
      t.string :name

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    SessionGroup.create_versioned_table
  end

  def down
    drop_table :session_groups
    SessionGroup.drop_versioned_table
  end
end
