class ConferenceWorkstream < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  translates :name, :byline, :language

  belongs_to :conference
end
