class Address < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  belongs_to :country
  belongs_to :online_application

  validates :street1, :presence => true, :length => { :maximum => 100 }, :if => :contact?
  validates :street2, :length => { :maximum => 100 }, :if => :contact?
  validates :street3, :length => { :maximum => 100 }, :if => :contact?
  validates :city, :presence => true, :length => { :maximum => 30 }, :if => :contact?
  validates :state, :length => { :maximum => 30 }, :if => :contact?
  validates :postal_code, :length => { :maximum => 20 }, :if => :contact?
  validates :postal_code, :format => { :with => /^(.{2,}|)$/, :message => I18n.t(:postal_code_invalid) }, :if => :contact?
  validates :country_id, :presence => true, :if => :contact?
  validates :other_country, :presence => true, :if => lambda { |a| contact? && a.country_id == 0 }
  validates :other_country, :length => { :maximum => 100 }, :if => lambda { |a| contact? && a.country_id == 0 }

  def contact?
    not online_application.status.nil? and online_application.status.include?('contact')
  end

end

