class Conference < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  translates :name, :byline

  attr_accessible

  belongs_to :session_group

  has_many :conference_workstreams

  # private is a reserved word
  scope :is_private, -> { where("private = ?", true) }
  # public is a reserved word
  scope :not_private, -> { where("private = ?", false) }
  scope :internal, -> { not_private.where("internal = ?", true) }
  scope :not_internal, -> { not_private.where("internal = ?", false) }
  scope :normal, -> { not_private.where("special = ? and caux_forum_training = ?", false, false) }
  scope :special, -> { not_private.where("special = ?", true) }
  scope :caux_forum_training, -> { not_private.where("caux_forum_training = ?", true) }

end
