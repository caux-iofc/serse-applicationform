class AddCauxForumTrainingToConferences < ActiveRecord::Migration
  def change
    add_column(:conferences, :caux_forum_training, :boolean, { :default => false, :null => false })
    add_column(:conference_versions, :caux_forum_training, :boolean, { :default => false, :null => false })
  end
end
