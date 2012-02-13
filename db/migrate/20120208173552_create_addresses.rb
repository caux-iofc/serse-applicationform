class CreateAddresses < ActiveRecord::Migration
  def up
    create_table :addresses do |t|
      t.references :online_application
      t.string :street1
      t.string :street2
      t.string :street3
      t.string :city
      t.string :postal_code
      t.string :state
      t.references :country
      t.string :other_country
      t.date :valid_from
      t.date :valid_until

      t.integer :addressable_id
      t.string  :addressable_type

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :addresses, :country_id
    Address.create_versioned_table
  end

  def down
    drop_table :addresses
    Address.drop_versioned_table
  end
end
