class Address < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  belongs_to :country
  belongs_to :online_application

  validates :street1, :presence => true, :length => { :maximum => 100 }
  validates :street2, :length => { :maximum => 100 }
  validates :street3, :length => { :maximum => 100 }
  validates :city, :presence => true, :length => { :maximum => 30 }
  validates :state, :length => { :maximum => 30 }
  validates :postal_code, :length => { :maximum => 20 }
  validates :postal_code, :format => { :with => /^(.{2,}|)$/, :message => I18n.t(:postal_code_invalid) }
  validates :country_id, :presence => true
  validates :other_country, :presence => true, :if => "country_id == 0"
  validates :other_country, :length => { :maximum => 100 }, :if => "country_id == 0"

end

