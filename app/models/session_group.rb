class SessionGroup < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible

  validates_presence_of  :name

  validates_uniqueness_of :name

end
