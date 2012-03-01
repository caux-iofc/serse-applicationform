class CreateOnlineForms < ActiveRecord::Migration
  def up
    create_table :online_forms do |t|
      t.references :session_group
      t.string :abbrev
      t.datetime :start
      t.datetime :stop
      t.integer :serse_id

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_forms, :session_group_id
    OnlineForm.create_versioned_table
  end

  def down
    OnlineForm.drop_versioned_table
    drop_table :online_forms
  end
end
