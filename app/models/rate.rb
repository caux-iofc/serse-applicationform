class Rate < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  validates :name, :uniqueness => true
  validates :name, :presence => true
  
  attr_accessible

  validates :from_age, :numericality => true
  validates :to_age, :numericality => true
  validates :from_age, :numericality => { :less_than_or_equal_to => :to_age, :message => " must be less than or equal to 'To age'" }

  default_scope { order('daily_chf') }

end
