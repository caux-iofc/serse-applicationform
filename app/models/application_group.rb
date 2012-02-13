class ApplicationGroup < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :session_group

  has_many :online_applications
end
