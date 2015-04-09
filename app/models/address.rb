class Address < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  belongs_to :country
  belongs_to :online_application

  validates :street1, :presence => true, :length => { :maximum => 100 }, :if => :personal?
  validates :street2, :length => { :maximum => 100 }, :if => :personal?
  validates :street3, :length => { :maximum => 100 }, :if => :personal?
  validates :city, :presence => true, :length => { :maximum => 30 }, :if => :personal?
  validates :state, :length => { :maximum => 30 }, :if => :personal?
  validates :postal_code, :length => { :maximum => 20 }, :if => :personal?
  validates :postal_code, :format => { :with => /^(.{2,}|)$/, :message => I18n.t(:postal_code_invalid) }, :if => :personal?
  validates :country_id, :presence => true, :if => :personal?
  validates :other_country, :presence => true, :if => lambda { |a| personal? && a.country_id == 0 }
  validates :other_country, :length => { :maximum => 100 }, :if => lambda { |a| personal? && a.country_id == 0 }

  def personal?
    # This gets the modified, 'dirty' version of online_application thanks to the ':inverse_of' set on
    # the has_one / belongs_to lines in the online_application, permanent_address and
    # correspondence_address models. Ward, 2015-03-28
    not self.online_application.status.nil? and self.online_application.status.include?('personal')
  end

end

