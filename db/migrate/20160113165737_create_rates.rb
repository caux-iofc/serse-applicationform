class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.column :name, :string, :limit => 200, :default => '', :null => false
      t.column :from_age, :integer, :default => 0, :null => false
      t.column :to_age, :integer, :default => 0, :null => false
      t.column :student, :boolean, :default => false, :null => false
      t.column :maintenance, :boolean, :default => false, :null => false

			t.column :daily_chf, :decimal, :default => 0, :null => false
			t.column :daily_eur, :decimal, :default => 0, :null => false
			t.column :daily_usd, :decimal, :default => 0, :null => false
      t.integer :serse_id

      t.column "created_at", :timestamp, :null => false
      t.column "updated_at", :timestamp, :null => false
      t.column "deleted_at", :timestamp
      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
    end
    if not ActiveRecord::Base.connection.table_exists? 'rate_versions'
      Rate.create_versioned_table
    else
      Rate.drop_versioned_table
    end
  end
end
