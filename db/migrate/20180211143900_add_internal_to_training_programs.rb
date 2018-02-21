class AddInternalToTrainingPrograms < ActiveRecord::Migration
  def change
    add_column(:training_programs, :internal, :boolean, { :default => true, :null => false })
    add_column(:training_program_versions, :internal, :boolean, { :default => true, :null => false })
  end
end
