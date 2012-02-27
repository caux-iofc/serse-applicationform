class CreateTrainingPrograms < ActiveRecord::Migration
  def up
    create_table :training_programs do |t|
      t.references :session_group
      t.boolean :display_dates
      t.timestamp :start
      t.timestamp :stop

      t.column "created_by", :string, :limit => 100, :null => false, :default => ''
      t.column "updated_by", :string, :limit => 100, :null => false, :default => ''
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "deleted_at", :timestamp
      t.timestamps
    end
    add_index :training_programs, :session_group_id
    TrainingProgram.create_versioned_table
    # See Globalize3: https://github.com/svenfuchs/globalize3
    TrainingProgram.create_translation_table! :name => :string, :byline => :string
  end

  def down
    drop_table :training_programs
    TrainingProgram.drop_versioned_table
    TrainingProgram.drop_translation_table!
  end
end
