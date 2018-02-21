class AddInternalToConferences < ActiveRecord::Migration
  def change
    add_column(:conferences, :internal, :boolean, { :default => false, :null => false })
    add_column(:conference_versions, :internal, :boolean, { :default => false, :null => false })
  end
end
