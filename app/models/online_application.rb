class OnlineApplication < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version

  belongs_to :application_group
  belongs_to :country, :foreign_key => :citizenship_id

  has_one :permanent_address, :dependent => :destroy, :inverse_of => :online_application
  has_one :correspondence_address, :dependent => :destroy, :inverse_of => :online_application

  accepts_nested_attributes_for :permanent_address,
    :allow_destroy => :true
  accepts_nested_attributes_for :correspondence_address,
    :allow_destroy => :true

  has_many :sponsors, :dependent => :destroy
  accepts_nested_attributes_for :sponsors, :allow_destroy => :true, :reject_if => :all_blank

  has_many :languages, :through => :online_application_languages
  has_many :online_application_languages, :dependent => :destroy
  accepts_nested_attributes_for :online_application_languages, :allow_destroy => :true, :reject_if => :all_blank

  has_many :online_application_diets
  has_many :diets, :through => :online_application_diets

  has_many :online_application_training_programs
  has_many :training_programs, :through => :online_application_training_programs
  accepts_nested_attributes_for :online_application_training_programs, :allow_destroy => :true, :reject_if => :not_selected, :update_only => :true

  has_many :conferences, :through => :online_application_conferences
  has_many :online_application_conferences, :order => 'priority_sort asc'
  accepts_nested_attributes_for :online_application_conferences, :allow_destroy => :true, :reject_if => :not_selected, :update_only => :true

  has_many :application_translation_needs

  # We need to build an OnlineApplicationConference object for every conference,
  # because we have conference sub forms that depend on that. So, we use a checkbox
  # called 'selected' to indicate if a conference was actually selected. If not
  # we do not save the OnlineApplicationConference object.
  def not_selected(attributed)
    attributed['selected'] == "0"
  end

  scope :primary_applicant, where("relation = 'primary applicant'")
  scope :other_applicants, where("relation != 'primary applicant'")

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
  attr_accessor :conference_speaker
  attr_accessor :week_of_international_community

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
                    :email => true, :if => lambda { |oa| personal_or_group_or_family? && (oa.relation == 'primary applicant' || oa.relation == 'other') }

  validates :telephone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }, :if => :personal?
  validates :telephone, :presence => true,
                        :if => lambda { |oa| personal? && oa.relation == 'primary applicant' }
  validates :cellphone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }, :if => :personal?
  validates :confirmation_letter_via, :presence => true, :if => lambda { |oa| personal? && oa.relation == 'primary applicant' }
  validates :work_telephone, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }, :if => :personal?
  validates :fax, :format => { :with => /^(\+[\d\/\-\. ]{6,}|)$/, :message => I18n.t(:phone_number_invalid) }, :if => :personal?
  validates :fax, :presence => true, :if => :fax_needed?
  def fax_needed?
    personal? and (confirmation_letter_via == "fax") and relation == 'primary applicant'
  end

  # /end personal

  # /begin detail

  validate :must_have_one_language, :if => :detail?

  def must_have_one_language
    if online_application_languages.empty? or online_application_languages.all? { |lang| lang.marked_for_destruction? } or online_application_languages.all? { |lang| lang.language_id.blank? || lang.proficiency.blank? }
      errors.add :base, I18n.t(:language_missing)
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

  # Whoa. Serious rough edge, can't use :presence => true here.
  # cf. http://stackoverflow.com/questions/4112858/radio-buttons-for-boolean-field-how-to-do-a-false
  validates :previous_visit, :inclusion => { :in => [ true, false ], :message => I18n.t(:previous_visit_unset) }, :if => lambda { |oa| dates_and_events? && oa.relation == 'primary applicant' }
  validates :previous_year, :presence => true, :format => { :with => /^([\d]{4}|)$/, :message => I18n.t(:previous_year_invalid) }, :if => lambda { |oa| dates_and_events? && oa.previous_visit }

  validates :heard_about, :presence => true, :length => { :maximum => 100 }, :if => lambda { |oa| dates_and_events? && !oa.previous_visit.nil? && !oa.previous_visit && oa.relation == 'primary applicant' }

  validates :day_visit, :inclusion => { :in => [ true, false ], :message => I18n.t(:day_visit_unset) }, :if => :dates_and_events?

  validate :must_select_reason_for_coming, :if => :dates_and_events?

  def must_select_reason_for_coming
    if online_application_conferences.select { |oac| oac.selected }.empty? and training_programs.empty? and
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
    if not online_application_conferences.select { |oac| oac.selected }.empty? and not training_programs.empty? then
      @real_locale = I18n.locale
      I18n.locale = 'en'
      training_programs.each do |tp|
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

    # Find earliest session start and latest session end
    @session_start = Time.now() + 30.years
    @session_stop = Time.now() - 30.years
    online_application_conferences.each do |oac|
      @session_start = oac.conference.start if oac.conference.start < @session_start
      @session_stop = oac.conference.stop if oac.conference.stop > @session_stop
    end
    training_programs.each do |tp|
      @session_start = tp.start if tp.start < @session_start
      @session_stop = tp.stop if tp.stop > @session_stop
    end

    # See if they selected a conference outside of their arrival/departure dates
    online_application_conferences.each do |oac|
      if (arrival > oac.conference.stop and departure > oac.conference.stop) or
         (arrival < oac.conference.start and departure < oac.conference.start) then
        errors.add :arrival, I18n.t(:a_conference_you_selected_does_not_overlap_with_your_stay_in_caux)
        errors.add :departure, I18n.t(:a_conference_you_selected_does_not_overlap_with_your_stay_in_caux)
        break
      end
    end

    # See if they selected a training program outside of their arrival/departure dates
    training_programs.each do |tp|
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
      @workstream_choice_required = true

      # Team members do not have to select workstreams
      @workstream_choice_required = false if oac.role_team

      # Special for LLWM 2012; people who select the course do not need to select workstreams
      if oac.variables.has_key?(:llmw_2012_advanced_course_for_young_peacemakers) and
         oac.variables['llmw_2012_advanced_course_for_young_peacemakers'] == '1' then
        @workstream_choice_required = false
      end

      # Special for TIGE 2015
      @real_locale = I18n.locale
      I18n.locale = 'en'
      if oac.conference.name == "Trust and integrity in the global economy"
        @workstream_choice_required = false
        if not oac.variables.has_key?(:tige_2015_options)
          errors.add :base, '<strong>'.html_safe + oac.conference.name + '</strong>: '.html_safe + I18n.t(:please_choose_option)
        end
      end
      I18n.locale = @real_locale

      if @workstream_choice_required then
        oac.online_application_conference_workstreams.each do |oacws|
          if oacws.conference_workstream_id.nil?
            errors.add :base, '<strong>'.html_safe + oac.conference.name + '</strong>: '.html_safe + I18n.t(:please_choose_preferred_workshops)
            break
          end
        end
      end

      # Exclude HS 2012, as well as conferences marked as 'special' from this validation
      # And exclude winter conference 2012/2013. TODO: fix this properly with a flag on the conference object.
      # And exclude winter conference 2014/2015. Sigh.
      # Cf. redmine #307. Ward, 2012-09-15
      # TODO: fix role detection properly; it should probably auto-populate based on what is present
      # in the forms.
      @real_locale = I18n.locale
      I18n.locale = 'en'
      if oac.conference.name != 'Fifth annual Caux Forum for Human Security' and
         oac.conference.name != 'Winter gathering 2012/13' and
         oac.conference.name != "Impact Initiatives Challenge" and
         oac.conference.name != 'Winter gathering 2014/15' and
         not oac.conference.special and
         not oac.role_participant and not oac.role_speaker and not oac.role_team and not oac.role_exhibitor then
         I18n.locale = @real_locale
        errors.add :base, '<strong>'.html_safe + oac.conference.name + '</strong>: '.html_safe + I18n.t(:please_indicate_conference_role)
      end
      I18n.locale = @real_locale
      oac.variables.each do |k,v|
        # Please note that checkboxes are *NOT* caught by this rule
        if v.nil? or v == '' then
          # TODO FIXME properly so that we don't need hardcoded lines like the next ones
          next if k == 'ipbf_2014_exhibitor_org_name' and not oac.role_exhibitor
          next if k == 'tige_2015_other_detail' and
                  ((oac.variables.has_key?(:tige_2015_options) and oac.variables[:tige_2015_options] != 'Other') or
                   not oac.variables.has_key?(:tige_2015_options))
          next if k == 'aeub_2015_expectations'
          next if k == 'aeub_2015_instrument'
          next if k == 'seed_2015_offer'

          errors.add :base, '<strong>'.html_safe + oac.conference.name + '</strong>: '.html_safe + I18n.t(:please_complete_all_required_fields)
          break
        end
      end
      oac.variables.each do |k,v|
        # Another HS 2012 special
        if k == 'hs_2012_confirm_registration_fee' and v == '0' then
          errors.add :base, '<strong>'.html_safe + oac.conference.name + '</strong>: '.html_safe + I18n.t(:please_confirm_chf_100_registration_fee)
        end
      end
    end
  end

  # /end dates_and_events
  # /begin visa

  validates :visa_reference_name, :presence => true, :if => :visa_reference_needed?
  validates :visa_reference_email, :presence => true,
                                   :email => true,
                                   :if => :visa_reference_needed?

  def visa_reference_needed?
    visa? and visa and relation == 'primary applicant'
  end

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
