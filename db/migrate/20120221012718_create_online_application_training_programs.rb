class CreateOnlineApplicationTrainingPrograms < ActiveRecord::Migration
  def up
    create_table :online_application_training_programs do |t|
      t.references :online_application
      t.references :training_program

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :online_application_training_programs, :online_application_id, :name => 'index_oa_training_programs_on_online_application_id'
    add_index :online_application_training_programs, :training_program_id, :name => 'index_oa_training_programs_on_training_program_id'
    OnlineApplicationTrainingProgram.create_versioned_table
  end

  def down
    drop_table :online_application_trainingprograms
    OnlineApplicationTrainingProgram.drop_versioned_table
  end

end
