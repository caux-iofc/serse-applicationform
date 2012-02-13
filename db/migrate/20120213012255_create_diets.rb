class CreateDiets < ActiveRecord::Migration
  def up 
    create_table :diets do |t|
      t.integer :priority_sort

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    Diet.create_versioned_table
    # See Globalize3: https://github.com/svenfuchs/globalize3
    Diet.create_translation_table! :name => :string
  end

  def down
    drop_table :diets
    Diet.drop_versioned_table
    Diet.drop_translation_table!
  end
end
