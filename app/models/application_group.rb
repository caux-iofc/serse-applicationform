class ApplicationGroup < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :name, :complete, :data_protection_consent, :data_protection_caux_info, :comment, :confirm_read_documents, :group_registration, :family_registration, :group_or_family_name, :online_applications_attributes, :data_protection_local_info, :payment_required, :payment_received

  # Used on the confirmation page
  attr_accessor :no_newsletters

  belongs_to :session_group

  has_many :online_applications, :dependent => :destroy
  accepts_nested_attributes_for :online_applications, :allow_destroy => true

  validates_associated :online_applications

  validates :data_protection_consent, :acceptance => { :accept => true, :message => I18n.t(:data_protection_consent_error) }
  validates :confirm_read_documents, :acceptance => { :accept => true, :message => I18n.t(:confirm_read_documents_error) }

  validates :group_or_family_name, :presence => true, :if => :group_or_family?

  def primary_applicant
    return self.online_applications.where('relation = ?','primary applicant').first
  end

  def group_or_family?
    # Ideally we'd be able to test here for the step in the multipage form,
    # but we can not (because inverse_of does not work with has_many as of Rails 3.2.21)
    self.group_registration or self.family_registration
  end

  scope :complete, -> { where("complete = ?", true) }

  def complete!
    self.complete = true
    self.save
    if self.primary_applicant and self.primary_applicant.email
      SystemMailer.notice_of_receipt("#{self.primary_applicant.pretty_name} <#{self.primary_applicant.email}>").deliver
    end
  end

end
