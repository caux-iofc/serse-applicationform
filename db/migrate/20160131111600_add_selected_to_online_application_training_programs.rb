class AddSelectedToOnlineApplicationTrainingPrograms < ActiveRecord::Migration
  def change
    add_column(:online_application_training_programs, :selected, :boolean, { :default => false, :null => false })
    add_column(:online_application_training_program_versions, :selected, :boolean, { :default => false, :null => false })
  end
end
