class ConferenceWorkstream < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  translates :name, :byline, :language

  attr_accessible

  belongs_to :conference

  default_scope { order('priority_sort') }
end
