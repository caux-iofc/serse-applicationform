class OnlineApplicationConference < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  # serialized field for custom conference variables
  serialize :variables, Hash 

  has_many :conference_workstreams, :through => :online_application_conference_workstreams
  has_many :online_application_conference_workstreams
  accepts_nested_attributes_for :online_application_conference_workstreams, :allow_destroy => :true, :reject_if => :all_blank, :update_only => true

  belongs_to :online_application
  belongs_to :conference

  # public is a reserved word
  scope :not_private, joins(:conference).where("conferences.private = ?", false)
  scope :normal, joins(:conference).where("conferences.special = ?", false)
  scope :special, joins(:conference).where("conferences.special = ?", true)

end
