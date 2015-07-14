class AddFullToConferences < ActiveRecord::Migration
  def change
    add_column(:conferences, :full, :boolean, { :default => false, :null => false })
    add_column(:conference_versions, :full, :boolean, { :default => false, :null => false })
  end
end
