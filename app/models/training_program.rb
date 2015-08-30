class TrainingProgram < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  translates :name, :byline

  attr_accessible

  belongs_to :session_group
end
