class OnlineApplicationLanguage < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application
  belongs_to :language

  validates :language_id, :presence => true, :if => lambda { |l| not l.proficiency.blank? && :personal? }
  validates :proficiency, :presence => true, :if => lambda { |l| not l.language_id.blank? && :personal? }

  def personal?
    not online_application.status.nil? and online_application.status.include?('personal')
  end

end
