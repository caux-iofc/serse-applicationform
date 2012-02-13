class CreateApplicationGroups < ActiveRecord::Migration
  def up
    create_table :application_groups do |t|
      t.string :name
      t.string :session_id, :null => false

      t.boolean :complete
      t.boolean :data_protection_consent
      t.boolean :data_protection_caux_info
      t.boolean :data_protection_three_local_events
      t.boolean :data_protection_local_info
      t.references :session_group
      t.text :comment

      t.string :browser

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :application_groups, :session_group_id
    ApplicationGroup.create_versioned_table
  end

  def down
    ApplicationGroup.drop_versioned_table
    drop_table :application_groups
  end
end
