class AddAutoToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :auto, :boolean, :default => false, :null => false
  end
end
