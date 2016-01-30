class CreateConferencePackages < ActiveRecord::Migration
  def change
    create_table :conference_packages do |t|
      t.references :conference
      t.decimal :price
      t.references :rate
      t.decimal :rate_nightly
      t.string :currency, :limit => 3
      t.integer :serse_id

      t.integer :created_by, :default => nil
      t.integer :updated_by, :default => nil
      t.integer :deleted_by, :default => nil
      t.integer :lock_version, :null => false, :default => 0
      t.timestamp :deleted_at
      t.timestamps
    end
    if not ActiveRecord::Base.connection.table_exists? 'conference_package_versions'
      ConferencePackage.create_versioned_table
    else
      ConferencePackage.drop_versioned_table
    end
  end
end
