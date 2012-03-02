class OnlineApplicationLanguage < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application
  belongs_to :language

  validates :language_id, :presence => true
  validates :proficiency, :presence => true

end
