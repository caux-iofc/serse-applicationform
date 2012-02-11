class OnlineApplication < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :application_group
  belongs_to :country, :foreign_key => :citizenship_id

  has_many :addresses, :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => :true

  has_many :sponsors, :dependent => :destroy
  accepts_nested_attributes_for :sponsors, :allow_destroy => :true, :reject_if => :all_blank

  validates :firstname, :presence => true
  validates :surname, :presence => true
  validates :gender, :presence => true
  # TODO: add if for kids! The 16 limit only applies to primary applicants
  validates :date_of_birth, :presence => true,
                            :date => { :before => Proc.new { Time.now - 16.years }, :message => 'must be at least 16 years ago' },
                            :date => { :after => Proc.new { Time.now - 110.years }, :message => 'can be no more than 110 years ago' }

  validates :citizenship_id, :presence => true
  validates :other_citizenship, :presence => true, :if => "citizenship_id == 0"

  validates :email, :confirmation => true,
                    :presence => true,
                    :email => true

  validates :email_confirmation, :presence => true
  validates :telephone, :presence => true,
                        :format => { :with => /^\+[\d\/\-\. ]{6,}$/, :message => I18n.t(:phone_number_invalid) }
  validates :cellphone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :confirmation_letter_via, :presence => true
  validates :work_telephone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :fax, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }
  validates :fax, :presence => true, :if => :fax_needed?
  def fax_needed?
    visa or confirmation_letter_via == "fax"
  end

  validates :arrival, :presence => true,
                      :date => { :before_or_equal_to => :departure, :message => ' must be before departure' },
                      :date => { :after_or_equal_to => Date.today, :message => 'can be no earlier than today'}
  validates :departure, :presence => true,
                        :date => { :after_or_equal_to => :arrival, :message => ' must be after arrival' }

  # Whoa. Serious rough edge, can't use :presence => true here. 
  # cf. http://stackoverflow.com/questions/4112858/radio-buttons-for-boolean-field-how-to-do-a-false
  validates :previous_visit, :inclusion => { :in => [ true, false ], :message => I18n.t(:previous_visit_unset) }
  validates :previous_year, :presence => true, :if => :previous_visit 
  validates :heard_about, :presence => true, :unless => "previous_visit.nil? or previous_visit"

  validates :visa_reference_name, :presence => true, :if => :visa
  validates :visa_reference_email, :presence => true, :if => :visa
  validates :passport_number, :presence => true, :if => :visa
  validates :passport_issue_place, :presence => true, :if => :visa
  validates :passport_issue_date, :presence => true,
                                  :date => { :before => Date.today, :message => I18n.t(:may_not_be_in_the_future) },
                                  :if => :visa
  validates :passport_expiry_date, :presence => true, 
  FIXME - cf. https://github.com/codegram/date_validator/
                                   :date => { :after => :departure + 3.months, :message => I18n.t(:must_be_valid_for_3_months_beyond_departure_date) },
                                   :if => :visa
  validates :passport_embassy, :presence => true, :if => :visa

  validates :nightly_contribution, :numericality => { :only_integer => true }

  validates :badge_firstname, :presence => true
  validates :badge_surname, :presence => true
  validates :badge_country, :presence => true

  validates_associated :addresses
  validates_associated :sponsors

end
