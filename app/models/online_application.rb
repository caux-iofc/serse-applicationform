class OnlineApplication < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  attr_accessible :date_of_birth, :relation, :firstname, :surname, :gender, :citizenship_id, :other_citizenship, :profession, :employer, :email, :telephone, :cellphone, :arrival, :departure, :previous_visit, :heard_about, :visa, :confirmation_letter_via, :accompanied_by, :passport_number, :passport_issue_date, :passport_issue_place, :passport_expiry_date, :passport_embassy, :nightly_contribution, :remarks, :badge_firstname, :badge_surname, :badge_country, :interpreter, :volunteer, :other_reason, :other_reason_detail, :staff, :staff_detail, :volunteer_detail, :diet_other_detail, :family_discount, :support_renovation_fund, :full_time_volunteer, :day_visit, :calculated_registration_fee, :calculated_night_rate, :calculated_total_personal_contribution, :calculated_nights, :calculated_rate_and_fee_details, :sent_by_employer, :student, :status, :rate, :financial_remarks, :online_application_conferences_attributes, :online_application_training_programs_attributes, :permanent_address_attributes, :different_address, :email_confirmation, :registration_type, :online_application_languages_attributes, :translate_english, :translate_french, :translate_german, :diet_ids, :caux_scholar, :caux_intern, :caux_artist, :conference_team, :conference_support, :conference_speaker, :week_of_international_community, :global_assembly, :caux_forum_training, :rate_per_night, :total_nights, :registration_fee, :sponsors_attributes, :communications_language_id

  belongs_to :application_group
  belongs_to :country, :foreign_key => :citizenship_id
  belongs_to :communications_language, :class_name => "Language"

  has_one :permanent_address, :dependent => :destroy, :inverse_of => :online_application

  accepts_nested_attributes_for :permanent_address,
    :allow_destroy => :true

  has_many :sponsors, :dependent => :destroy
  accepts_nested_attributes_for :sponsors, :allow_destroy => :true, :reject_if => :all_blank

  has_many :languages, :through => :online_application_languages
  has_many :online_application_languages, :dependent => :destroy
  accepts_nested_attributes_for :online_application_languages, :allow_destroy => :true, :reject_if => :all_blank

  has_many :online_application_diets
  has_many :diets, :through => :online_application_diets

  has_many :training_programs, :through => :online_application_training_programs
  has_many :online_application_training_programs
  accepts_nested_attributes_for :online_application_training_programs, :allow_destroy => :true, :reject_if => :not_selected, :update_only => :true

  has_many :conferences, :through => :online_application_conferences
  has_many :online_application_conferences

  accepts_nested_attributes_for :online_application_conferences, :allow_destroy => :true, :reject_if => :not_selected, :update_only => :true

  has_many :application_translation_needs

  # We need to build an OnlineApplicationConference object for every conference,
  # because we have conference sub forms that depend on that. So, we use a checkbox
  # called 'selected' to indicate if a conference was actually selected. If not
  # we do not save the OnlineApplicationConference object.
  def not_selected(attributed)
    attributed['selected'] == "0"
  end

  scope :primary_applicant, -> { where("relation = 'primary applicant'") }
  scope :other_applicants, -> { where("relation != 'primary applicant'") }

  attr_accessor :the_request

  # we translate these into ApplicationTranslationNeed records
  attr_accessor :translate_english, :translate_french, :translate_german

  attr_accessor :registration_type
  attr_accessor :group_name

  attr_accessor :rate_per_night
  attr_accessor :total_nights
  attr_accessor :registration_fee


  attr_accessor :different_address

  # these accessors are used in the finance step to pass information to the javascript
  # that calculates the rates
  attr_accessor :caux_scholar
  attr_accessor :caux_intern
  attr_accessor :caux_artist
  attr_accessor :conference_team
  attr_accessor :conference_support
  attr_accessor :conference_speaker
  attr_accessor :week_of_international_community
  attr_accessor :global_assembly
  attr_accessor :caux_forum_training

  before_validation do
    # Filter out duplicate online_application_conference records. This can happen when
    # the dates_and_events form is submitted twice on first submit.
    # Sadly, rails basically doesn't support doing this on has_many through, cf.
    #   http://blog.spoolz.com/2012/12/21/rails-nested-attributes-with-scoped-uniqueness-validation-of-association/
    self.online_application_conferences = self.online_application_conferences.select do |oac|
      not oac.id.nil? or OnlineApplication.find(self.id).online_application_conferences.where('online_application_id = ?',self.id).empty?
    end
    # Filter out duplicated online_application_training_programs records.
    self.online_application_training_programs = self.online_application_training_programs.select do |oatp|
      not oatp.id.nil? or OnlineApplication.find(self.id).online_application_training_programs.where('online_application_id = ?',self.id).empty?
    end

    # Throw a proper error when duplicate online_application_conference+languages are
    # selected, because of bug #4568:
    #   https://github.com/rails/rails/issues/4568
    self.online_application_languages.each do |oal|
      if self.online_application_languages.select { |l| not oal.language.nil? and not l.language.nil? and l.language.id == oal.language.id }.count > 1
        # draw the red boxes around the offending language names
        oal.errors.add(:language_id,I18n.t(:selected_multiple_times))
        # show the error to the user, by saving it on self.errors
        if not errors.messages.include?(:"online_application_languages.language_id")
          errors.add(:"online_application_languages.language_id",I18n.t(:selected_multiple_times))
        end
      end
    end
  end

  after_validation() do
    # Keep track of validation errors, so that we can improve the user experience
    if not errors.empty? then
      messages = ''
      errors.messages.each do |k,v|
        if k != :base then
          messages += "#{k}: #{v}\n"
        else
          v.each do |v2|
            @tmp = v2.split(':',2)
            @key = @tmp[0]
            @key.gsub!(/<\/?[^>]*>/, "")
            @val = @tmp[1]
            @val = '' if @val.nil?
            @val.gsub!(/<\/?[^>]*>/, "")
            messages += "#{@key}: #{@val}\n"
          end
        end
      end
      SystemMailer.validation_failure_notification(messages,self.the_request).deliver
    end
  end

  before_validation :strip_whitespace
  before_validation :set_name_badge_fields

  # /begin personal

  validates :relation, :inclusion => { :in => [ 'primary applicant', 'spouse', 'child', 'other' ], :message => I18n.t(:only_valid_relations) }, :if => :personal_or_family?
  validates :firstname, :presence => true, :if => :personal_or_group_or_family?
  validates :surname, :presence => true, :if => :personal_or_group_or_family?

  validates :firstname, :uniqueness => {:scope => [ :surname, :gender, :date_of_birth, :application_group_id ], :message => I18n.t(:duplicate_person_in_application_group) }, :if => :personal_or_group_or_family?

  validates :gender, :presence => true, :if => :personal_or_group_or_family?
  validates :date_of_birth, :presence => true, :if => :personal_or_group_or_family?
  # There appears to be no way to pass two different :date conditions with a unique message for each
  # in one validates statement. So we make sure to put each :date condition in a separate validates statement.
  # In this particular case, we had to do that anyway because the age minimum only applies to primary applicants.
  validates :date_of_birth, :date => { :after => Proc.new { Time.now - 110.years }, :message => I18n.t(:max_age_110) }, :if => lambda { |oa| personal_or_group_or_family? && oa.date_of_birth }
  validates :date_of_birth, :date => { :before => Proc.new { Time.now - 16.years }, :message => I18n.t(:min_age_16) }, :if => lambda { |oa| personal_or_group_or_family? && oa.date_of_birth && oa.relation == 'primary applicant' }

  validates :citizenship_id, :presence => true, :if => :personal_or_group_or_family?
  validates :other_citizenship, :presence => true, :if => lambda { |oa| personal_or_group_or_family? && oa.citizenship_id == 0 }

  validates :email, :confirmation => true,
                    :presence => true,
                    :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :if => lambda { |oa| personal_or_group_or_family? && (oa.relation == 'primary applicant' || oa.relation == 'other') }

  validates :telephone, :format => { :with => /\A(\+[\d\/\-\. ]{6,}|)\z/, :message => I18n.t(:phone_number_invalid) }, :if => :personal?
  validates :telephone, :presence => true,
                        :if => lambda { |oa| personal? && oa.relation == 'primary applicant' }
  validates :cellphone, :format => { :with => /\A(\+[\d\/\-\. ]{6,}|)\z/, :message => I18n.t(:phone_number_invalid) }, :if => :personal?
  validates :confirmation_letter_via, :presence => true, :if => lambda { |oa| personal? && oa.relation == 'primary applicant' }
  validates :profession, :presence => true,
                        :if => lambda { |oa| personal_or_group_or_family? && oa.relation != 'child' }
  validates :employer, :presence => true,
                        :if => lambda { |oa| personal_or_group_or_family? && oa.relation != 'child' }
  # /end personal

  # /begin detail

  validates :communications_language, :presence => true, :if => :detail?
  validate :must_have_one_language, :if => :detail?

  def must_have_one_language
    if online_application_languages.empty? or online_application_languages.all? { |lang| lang.marked_for_destruction? } or online_application_languages.all? { |lang| lang.language_id.blank? || lang.proficiency.blank? }
      errors.add :base, I18n.t(:language_missing)
    end
  end

  validate :must_have_one_menu, :if => :detail?
  validate :no_more_than_one_diet, :if => :detail?

  def must_have_one_menu
    if diets.menu.empty? or diets.menu.all? { |diet| diet.marked_for_destruction? }
      errors.add :base, I18n.t(:menu_missing)
    end
  end

  def no_more_than_one_diet
    if diets.diet.size > 1
      errors.add :base, I18n.t(:no_more_than_one_diet_choice)
    end
  end

  validates :diet_other_detail, :length => { :maximum => 240 }, :if => :detail?

  # /end detail

  # /begin dates_and_events

  # There appears to be no way to pass two different :date conditions with a unique message for each
  # in one validates statement. So we make sure to put each :date condition in a separate validates statement.
  validates :arrival, :presence => true,
                      :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }

  # Validate arrival < departure
  validates :arrival, :date => { :before => :departure, :message => I18n.t(:must_be_before_departure) },
                      :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }

  # Validate presence of departure, and departure > arrival
  validates :departure, :presence => true,
                        :date => { :after => :arrival, :message => I18n.t(:must_be_after_arrival) },
                        :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }

  unless ALLOW_RETROACTIVE_REGISTRATION
    validates :arrival, :date => { :after_or_equal_to => Date.today, :message => I18n.t(:can_be_no_earlier_than_today) },
                        :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }
    validates :departure, :date => { :after_or_equal_to => Date.today, :message => I18n.t(:can_be_no_earlier_than_today) },
                          :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }
  end

  validates :heard_about, :presence => true, :length => { :maximum => 100 }, :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }

  validates :day_visit, :inclusion => { :in => [ true, false ], :message => I18n.t(:day_visit_unset) }, :if => :dates_and_events?

  validate :must_select_reason_for_coming, :if => :dates_and_events?

  def must_select_reason_for_coming
    if online_application_conferences.select { |oac| oac.selected }.empty? and
       online_application_training_programs.select { |oac| oac.selected }.empty? and
       not staff and not interpreter and not volunteer and not other_reason and
       not relation == 'child' then
      errors.add :other_reason, I18n.t(:please_indicate_other_reason).html_safe
    end
  end

  validates :other_reason_detail, :length => { :maximum => 200 }, :if => :dates_and_events?
  validates :other_reason_detail, :presence => { :value => true, :message => I18n.t(:please_specify_your_reason) }, :if => lambda { |oa| dates_and_events? && oa.other_reason }

  validates :staff_detail, :presence => { :value => true, :message => I18n.t(:please_specify_your_position_department) }, :if => lambda { |oa| dates_and_events? && oa.staff }
  validates :volunteer_detail, :presence => { :value => true, :message => I18n.t(:please_specify_your_position_department) }, :if => lambda { |oa| dates_and_events? && oa.volunteer }

  validate :scholars_interns_interpreters_can_not_select_conferences, :if => :dates_and_events?

  def scholars_interns_interpreters_can_not_select_conferences
    if interpreter and not online_application_conferences.select { |oac| oac.selected }.empty? then
      errors.add :base, I18n.t(:if_you_come_as_an_interpreter_please_do_not_select_a_conference_html).html_safe
    end
    if not online_application_conferences.select { |oac| oac.selected }.empty? and
       not online_application_training_programs.select { |oatp| oatp.selected }.empty? then
      @real_locale = I18n.locale
      I18n.locale = 'en'
      online_application_training_programs.select { |oatp| oatp.selected }.each do |oatp|
        tp = oatp.training_program
        if tp.name =~ /Caux Interns/ then
          I18n.locale = @real_locale
          errors.add :base, I18n.t(:if_you_come_as_a_caux_intern_please_do_not_select_a_conference_html).html_safe
        end
        if tp.name =~ /Caux Scholars/ then
          I18n.locale = @real_locale
          errors.add :base, I18n.t(:if_you_come_as_a_caux_scholar_please_do_not_select_a_conference_html).html_safe
        end
      end
    end
  end

  validate :arrival_and_departures_match_session_dates, :if => :dates_and_events?

  def arrival_and_departures_match_session_dates
    # Only complain if they've provided arrival/departure
    return if arrival.nil?
    return if departure.nil?

    # See if they selected a conference outside of their arrival/departure dates
    online_application_conferences.select { |oatp| oatp.selected }.each do |oac|
      if (arrival > oac.conference.stop and departure > oac.conference.stop) or
         (arrival < oac.conference.start and departure < oac.conference.start) then
        errors.add :arrival, I18n.t(:a_conference_you_selected_does_not_overlap_with_your_stay_in_caux)
        errors.add :departure, I18n.t(:a_conference_you_selected_does_not_overlap_with_your_stay_in_caux)
        break
      end
    end

    # See if they selected a training program outside of their arrival/departure dates
    online_application_training_programs.select { |oatp| oatp.selected }.each do |oatp|
      tp = oatp.training_program
      if (arrival > tp.stop and departure > tp.stop) or
         (arrival < tp.start and departure < tp.start) then
        errors.add :arrival, I18n.t(:a_training_program_you_selected_does_not_overlap_with_your_stay_in_caux)
        errors.add :departure, I18n.t(:a_training_program_you_selected_does_not_overlap_with_your_stay_in_caux)
        break
      end
    end
  end

  validate  :sub_forms, :if => :dates_and_events?

  def sub_forms
    online_application_conferences.each do |oac|
      oac.variables.each do |k,v|
        if v.nil? or v == '' then
          # reference person field is only shown and required when role is not participant
          next if k == 'team_member_reference_person' and oac.variables[:role] == 'participant'
          errors.add :base, '<strong>'.html_safe + oac.conference.name + '</strong>: '.html_safe + I18n.t(:please_complete_all_required_fields)
          break
        end
      end
    end
  end

  # /end dates_and_events
  # /begin visa

  validates :passport_number, :presence => true, :if => lambda { |oa| visa? && oa.visa }
  validates :passport_issue_place, :presence => true, :if => lambda { |oa| visa? && oa.visa }
  validates :passport_issue_date, :presence => true,
                                  :date => { :before => Date.today, :message => I18n.t(:may_not_be_in_the_future) },
                                  :if => lambda { |oa| visa? && oa.visa }

  validates :passport_expiry_date, :presence => true,
                                   :date => { :after => :three_months_after_departure, :message => I18n.t(:must_be_valid_for_3_months_beyond_departure_date) },
                                   :if => lambda { |oa| visa? && oa.visa && oa.departure }

  # We need to use this proc because date_validator can not handle ':departure + 3.months' itself
  def three_months_after_departure
    if not departure.nil? then
      return departure + 3.months
    else
      return Time.now()
    end
  end

  validates :passport_embassy, :presence => true, :if => lambda { |oa| visa? && oa.visa }
  # /end visa

  # /begin finance

  #validates :night_rate, :numericality => { :only_integer => true , :message => I18n.t(:night_rate_invalid) }
  #validates :reservation_fee, :numericality => { :only_integer => true , :message => I18n.t(:reservation_fee_invalid) }
  #validates :nightly_contribution, :numericality => { :only_integer => true , :message => I18n.t(:nightly_contribution_invalid) }

  # /end finance

  # /begin confirmation

  validates :badge_firstname, :presence => true, :if => :confirmation?
  validates :badge_surname, :presence => true, :if => :confirmation?
  validates :badge_country, :presence => true, :if => :confirmation?

  # /end confirmation

  def personal?
    if relation == 'primary applicant'
      not status.nil? and status.include?('personal')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('personal')
    end
  end

  def personal_or_family?
    if relation == 'primary applicant'
      not status.nil? and (status.include?('personal') or status.include?('family'))
    else
      not application_group.primary_applicant.status.nil? and
       (application_group.primary_applicant.status.include?('personal') or
        application_group.primary_applicant.status.include?('family'))
    end
  end

  def group?
    if relation == 'primary applicant'
      not status.nil? and status.include?('group')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('personal')
    end
  end

  def personal_or_group_or_family?
    if relation == 'primary applicant'
      not status.nil? and (status.include?('personal') or status.include?('group') or status.include?('family'))
    else
      not application_group.primary_applicant.status.nil? and
       (application_group.primary_applicant.status.include?('personal') or
        application_group.primary_applicant.status.include?('group') or
        application_group.primary_applicant.status.include?('family'))
    end
  end

  def detail?
    if relation == 'primary applicant'
      not status.nil? and status.include?('detail')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('detail')
    end
  end

  def dates_and_events?
    if relation == 'primary applicant'
      not status.nil? and status.include?('dates_and_events')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('dates_and_events')
    end
  end

  def visa?
    if relation == 'primary applicant'
      not status.nil? and status.include?('visa')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('visa')
    end
  end

  def finances?
    if relation == 'primary applicant'
      not status.nil? and status.include?('finances')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('finances')
    end
  end

  def confirmation?
    if relation == 'primary applicant'
      not status.nil? and status.include?('confirmation')
    else
      not application_group.primary_applicant.status.nil? and application_group.primary_applicant.status.include?('confirmation')
    end
  end

  def pretty_name
    if self.firstname and self.surname
      self.firstname + ' ' + self.surname
    elsif self.firstname
      self.firstname
    elsif self.surname
      self.surname
    else
      ''
    end
  end

private

  def strip_whitespace
    # trim whitespace from beginning and end of string attributes
    attribute_names.each do |name|
      if send(name).respond_to?(:strip)
        send("#{name}=", send(name).strip)
      end
    end
  end

  # Default name badge fields to the values from the application.
  def set_name_badge_fields
    if firstname != '' and badge_firstname.nil?
      self.badge_firstname = firstname
    end
    if surname != '' and badge_surname.nil?
      self.badge_surname = surname
    end
    if not citizenship_id.nil? and citizenship_id != '' and badge_country.nil?
      if citizenship_id != 0
        self.badge_country = self.country.name
      else
        self.badge_country = other_citizenship
      end
    end
  end
end
