class OnlineApplicationDiet < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :online_application_id, :diet_id

  belongs_to :online_application
  belongs_to :diet
end
