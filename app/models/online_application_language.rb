class OnlineApplicationLanguage < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :online_application_id, :language_id, :proficiency

  belongs_to :online_application
  belongs_to :language

  validates :language_id, :presence => true, :if => lambda { |l| not l.proficiency.blank? && :personal? }
  validates :proficiency, :presence => true, :if => lambda { |l| not l.language_id.blank? && :personal? }

  # This works but only when updating. Cf. bug https://github.com/rails/rails/issues/4568
  # We catch the insertion of multiple identical languages
  # through a before_validation hook on the online_application model.
  validates :language_id, :uniqueness => { :scope => :online_application_id }

  def personal?
    not online_application.status.nil? and online_application.status.include?('personal')
  end

end
