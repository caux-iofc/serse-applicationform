class ApplicationTranslationNeed < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  has_many :online_applications
  has_many :languages

end
