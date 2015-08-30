class ApplicationTranslationNeed < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  has_many :online_applications
  has_many :languages

  attr_accessible :language_id, :online_application_id

end
