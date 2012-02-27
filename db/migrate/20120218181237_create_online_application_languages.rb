class CreateOnlineApplicationLanguages < ActiveRecord::Migration
  def up
    create_table :online_application_languages do |t|
      t.references :online_application
      t.references :language
      t.integer :proficiency

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_application_languages, :online_application_id
    add_index :online_application_languages, :language_id
    OnlineApplicationLanguage.create_versioned_table
  end

  def down
    drop_table :online_application_languages
    OnlineApplicationLanguage.drop_versioned_table
  end
end
