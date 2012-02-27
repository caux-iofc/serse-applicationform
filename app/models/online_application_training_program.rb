class OnlineApplicationTrainingProgram < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application
  belongs_to :training_program
end
