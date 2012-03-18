class ApplicationGroup < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :session_group

  has_many :online_applications

  validates :data_protection_consent, :acceptance => { :accept => true, :message => I18n.t(:confirm_read_documents_error) }
  validates :confirm_read_documents, :acceptance => { :accept => true, :message => I18n.t(:data_protection_consent_error) }

  def primary_applicant
    return self.online_applications.where('relation = ?','primary applicant').first
  end

  scope :complete, where("complete = ?", true)
end
