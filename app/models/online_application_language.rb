class OnlineApplicationLanguage < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :online_application_id, :language_id, :proficiency

  belongs_to :online_application
  belongs_to :language

  validates :online_application_id, :presence => true

  validates :language_id, :presence => true, :if => lambda { |l| not l.proficiency.blank? and detail? }
  validates :proficiency, :presence => true, :if => lambda { |l| not l.language_id.blank? and detail? }

  # This works but only when updating. Cf. bug https://github.com/rails/rails/issues/4568
  # We catch the insertion of multiple identical languages
  # through a before_validation hook on the online_application model.
  validates :language_id, :uniqueness => { :scope => :online_application_id }

private

  def detail?
    not online_application.nil? and not online_application.status.nil? and online_application.status.include?('detail')
  end

end
