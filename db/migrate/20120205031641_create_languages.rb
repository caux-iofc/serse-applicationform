class CreateLanguages < ActiveRecord::Migration
  def up
    create_table :languages do |t|
      t.string :name
      t.integer :priority_sort

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    Language.create_versioned_table
  end

  def down
    drop_table :languages
    Language.drop_versioned_table
  end
end
