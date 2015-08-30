class OnlineApplicationTrainingProgram < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :online_application_id, :training_program_id

  belongs_to :online_application
  belongs_to :training_program
end
