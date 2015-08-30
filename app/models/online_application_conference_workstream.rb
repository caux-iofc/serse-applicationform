class OnlineApplicationConferenceWorkstream < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :online_application_conference_id, :conference_workstream_id, :preference

  belongs_to :online_application_conference
  belongs_to :conference_workstream
end
