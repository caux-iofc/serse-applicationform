class CreateApplicationTranslationNeeds < ActiveRecord::Migration
  def up
    create_table :application_translation_needs do |t|
      t.references :online_application
      t.references :language

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    ApplicationTranslationNeed.create_versioned_table
  end

  def down
    drop_table :application_translation_needs
    ApplicationTranslationNeed.drop_versioned_table
  end
end
