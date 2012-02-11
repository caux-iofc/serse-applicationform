class CreateSponsors < ActiveRecord::Migration
  def up
    create_table :sponsors do |t|
      t.references :online_application
      t.string :name
      t.integer :nights
      t.integer :amount

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :sponsors, :online_application_id
    Sponsor.create_versioned_table
  end

  def down
    drop_table :sponsors
    Sponsor.drop_versioned_table
  end
end
