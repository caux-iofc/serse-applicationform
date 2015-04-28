class Address < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  belongs_to :country
  belongs_to :online_application

  validates :street1, :presence => true, :length => { :maximum => 100 }, :if => :personal_or_group?
  validates :street2, :length => { :maximum => 100 }, :if => :personal_or_group?
  validates :street3, :length => { :maximum => 100 }, :if => :personal_or_group?
  validates :city, :presence => true, :length => { :maximum => 30 }, :if => :personal_or_group?
  validates :state, :length => { :maximum => 30 }, :if => :personal_or_group?
  validates :postal_code, :length => { :maximum => 20 }, :if => :personal_or_group?
  validates :postal_code, :format => { :with => /^(.{2,}|)$/, :message => I18n.t(:postal_code_invalid) }, :if => :personal_or_group?
  validates :country_id, :presence => true, :if => :personal_or_group?
  validates :other_country, :presence => true, :if => lambda { |a| personal_or_group? && a.country_id == 0 }
  validates :other_country, :length => { :maximum => 100 }, :if => lambda { |a| personal_or_group? && a.country_id == 0 }

  def personal?
    # This gets the modified, 'dirty' version of online_application thanks to the ':inverse_of' set on
    # the has_one / belongs_to lines in the online_application, permanent_address and
    # correspondence_address models. Ward, 2015-03-28
    not self.online_application.status.nil? and self.online_application.status.include?('personal')
  end

  def personal_or_group?
    if self.online_application.relation == 'primary applicant'
      not self.online_application.status.nil? and
        (self.online_application.status.include?('personal') or
         self.online_application.status.include?('group'))
    else
      not self.online_application.application_group.primary_applicant.status.nil? and
        (self.online_application.application_group.primary_applicant.status.include?('personal') or
         self.online_application.application_group.primary_applicant.status.include?('group'))
    end
  end

  def empty?
    (street1.nil? or street1.empty?) and
    (street2.nil? or street2.empty?) and
    (street3.nil? or street3.empty?) and
    (city.nil? or city.empty?) and
    (state.nil? or state.empty?) and
    (postal_code.nil? or postal_code.empty?) and
    country_id.nil? and
    (other_country.nil? or other_country.empty?)
  end

end

