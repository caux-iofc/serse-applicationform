class CreateLanguages < ActiveRecord::Migration
  def up
    create_table :languages do |t|
      t.integer :priority_sort
      t.integer :serse_id

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    Language.create_versioned_table
    # See Globalize3: https://github.com/svenfuchs/globalize3
    Language.create_translation_table! :name => :string
  end

  def down
    drop_table :languages
    Language.drop_versioned_table
    Language.drop_translation_table!
  end
end
