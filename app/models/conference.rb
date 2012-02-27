class Conference < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  translates :name, :byline

  belongs_to :session_group

  has_many :conference_workstreams

  # public is a reserved word
  scope :not_private, where("private = ?", false)
  scope :normal, where("special = ?", false)
  scope :special, where("special = ?", true)

end
