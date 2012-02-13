class CreateOnlineApplicationDiets < ActiveRecord::Migration
  def up
    create_table :online_application_diets do |t|
      t.references :online_application
      t.references :diet

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_application_diets, :online_application_id
    add_index :online_application_diets, :diet_id
    OnlineApplicationDiet.create_versioned_table
  end

  def down
    drop_table :online_application_diets
    OnlineApplicationDiet.drop_versioned_table
  end
end
