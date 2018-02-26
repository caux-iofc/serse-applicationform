class ApplicationTranslationNeed < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application, :inverse_of => :application_translation_needs
  belongs_to :language

  attr_accessible :language_id, :online_application_id, :need

end
