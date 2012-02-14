class OnlineApplication < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :application_group
  belongs_to :country, :foreign_key => :citizenship_id

  has_one :permanent_address, :dependent => :destroy
  has_one :correspondence_address, :dependent => :destroy

  accepts_nested_attributes_for :permanent_address, 
    :allow_destroy => :true
  accepts_nested_attributes_for :correspondence_address, 
    :allow_destroy => :true

  has_many :sponsors, :dependent => :destroy
  accepts_nested_attributes_for :sponsors, :allow_destroy => :true, :reject_if => :all_blank

  has_many :online_application_diets
  has_many :diets, :through => :online_application_diets, :dependent => :destroy


  before_validation() do
    # We only care about the correspondence address if we need it
    if not self.correspondence_address.nil? and 
       self.confirmation_letter_via != "correspondence_address" then
      self.correspondence_address.destroy! 
    end
  end

  validates :firstname, :presence => true
  validates :surname, :presence => true

  validates :firstname, :uniqueness => {:scope => [ :surname, :gender, :date_of_birth, :application_group_id ], :message => I18n.t(:duplicate_person_in_application_group) }

  validates :gender, :presence => true
  validates :date_of_birth, :presence => true
  # There appears to be no way to pass two different :date conditions with a unique message for each
  # in one validates statement. So we make sure to put each :date condition in a separate validates statement.
  # In this particular case, we had to do that anyway because the age minimum only applies to primary applicants.
  validates :date_of_birth, :date => { :after => Proc.new { Time.now - 110.years }, :message => I18n.t(:max_age_110) }, :if => :date_of_birth
  validates :date_of_birth, :date => { :before => Proc.new { Time.now - 16.years }, :message => I18n.t(:min_age_16) }, :if => "date_of_birth and relation != 'child'"

  validates :citizenship_id, :presence => true
  validates :other_citizenship, :presence => true, :if => "citizenship_id == 0"

  validates :email, :confirmation => true,
                    :presence => true,
                    :email => true

  validates :email_confirmation, :presence => true
  validates :telephone, :presence => true,
                        :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :cellphone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :confirmation_letter_via, :presence => true
  validates :work_telephone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :fax, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :fax, :presence => true, :if => :fax_needed?
  def fax_needed?
    visa or confirmation_letter_via == "fax"
  end

  # There appears to be no way to pass two different :date conditions with a unique message for each
  # in one validates statement. So we make sure to put each :date condition in a separate validates statement.
  validates :arrival, :presence => true,
                      :date => { :before_or_equal_to => :departure, :message => I18n.t(:must_be_before_departure) }
  validates :arrival, :date => { :after_or_equal_to => Date.today, :message => I18n.t(:can_be_no_earlier_than_today) }
  validates :departure, :presence => true,
                        :date => { :after_or_equal_to => :arrival, :message => I18n.t(:must_be_after_arrival) }
  validates :departure, :date => { :after_or_equal_to => Date.today, :message => I18n.t(:can_be_no_earlier_than_today) }

  # Whoa. Serious rough edge, can't use :presence => true here. 
  # cf. http://stackoverflow.com/questions/4112858/radio-buttons-for-boolean-field-how-to-do-a-false
  validates :previous_visit, :inclusion => { :in => [ true, false ], :message => I18n.t(:previous_visit_unset) }
  validates :previous_year, :presence => true, :format => { :with => /^([\d]{4}|)$/, :message => I18n.t(:previous_year_invalid) }, :if => :previous_visit 
  validates :heard_about, :presence => true, :unless => "previous_visit.nil? or previous_visit"

  validates :visa_reference_name, :presence => true, :if => :visa
  validates :visa_reference_email, :presence => true, :if => :visa
  validates :passport_number, :presence => true, :if => :visa
  validates :passport_issue_place, :presence => true, :if => :visa
  validates :passport_issue_date, :presence => true,
                                  :date => { :before => Date.today, :message => I18n.t(:may_not_be_in_the_future) },
                                  :if => :visa
  
  validates :passport_expiry_date, :presence => true, 
                                   :date => { :after => :three_months_after_departure, :message => I18n.t(:must_be_valid_for_3_months_beyond_departure_date) },
                                   :if => :visa
  # We need to use this proc because date_validator can not handle ':departure + 3.months' itself
  def three_months_after_departure
    departure + 3.months
  end
                                   
  validates :passport_embassy, :presence => true, :if => :visa

  validates :nightly_contribution, :numericality => { :only_integer => true }

  validates :badge_firstname, :presence => true
  validates :badge_surname, :presence => true
  validates :badge_country, :presence => true

  validates_associated :sponsors

end
