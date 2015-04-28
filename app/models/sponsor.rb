class Sponsor < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :online_application

  validates :nights, :numericality => { :only_integer => true }, :if => :nights
  validates :amount, :numericality => { :only_integer => true }, :if => :amount

  validates :name, :presence => true, :if => Proc.new { |s| not s.nights.blank? or not s.amount.blank? }
  validates :nights, :presence => true, :if => Proc.new { |s| not s.name.blank? or not s.amount.blank? }
  validates :amount, :presence => true, :if => Proc.new { |s| not s.name.blank? or not s.nights.blank? }

  scope :auto, where("auto = ?", true)
  scope :not_auto, where("auto = ?", false)

end
