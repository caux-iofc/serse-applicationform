class Sponsor < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application
#  validates_presence_of :online_application

  validates :nights, :numericality => { :only_integer => true }, :if => :nights
  validates :amount, :numericality => { :only_integer => true }, :if => :amount
end
