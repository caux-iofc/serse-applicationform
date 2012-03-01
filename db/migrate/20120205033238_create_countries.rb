class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries do |t|
      t.integer :zipcode_order
      t.integer :state_order
      t.integer :serse_id

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    Country.create_versioned_table
    # See Globalize3: https://github.com/svenfuchs/globalize3
    Country.create_translation_table! :name => :string
  end

  def down
    drop_table :countries
    Country.drop_versioned_table
    Country.drop_translation_table!
  end
end
