class Diet < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  translates :name

  attr_accessible

  scope :menu, -> { where("menu = ?", true) }
  scope :diet, -> { where("menu = ?", false) }

  has_many :online_application_diets
  has_many :online_applications, :through => :online_application_diets, :dependent => :destroy

end
