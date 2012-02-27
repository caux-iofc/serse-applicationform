class OnlineApplicationConferenceWorkstream < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application_conference
  belongs_to :conference_workstream
end
