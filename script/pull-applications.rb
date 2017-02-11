#!/usr/bin/env ruby

# THIS SCRIPT NEEDS TO BE RUN IN FLOCK #

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def load_configuration
  default_config_filepath = File.join(Rails.root, 'config', 'serse.defaults.yml')
  site_config_filepath = File.join(Rails.root, 'config', 'serse.yml')

  # Load the configuration defaults first
  if not File.exists?(default_config_filepath)
    die("Could not find #{default_config_filepath}")
  end

  default_config = YAML::load(ERB.new(IO.read(default_config_filepath)).result)

  default_config_common = default_config['common']
  default_config_environment = default_config[::Rails.env.to_s]

  default_config_common ||= {}
  default_config_environment ||= {}

  if File.exists?(site_config_filepath)
    site_config_environment = YAML::load(ERB.new(IO.read(site_config_filepath)).result)[::Rails.env.to_s]
    site_config_environment ||= {}
    return default_config_common.merge(default_config_environment).merge(site_config_environment)
  else
    return default_config_common.merge(default_config_environment)
  end
end

APP_CONFIG = load_configuration

def pg_connect
  require 'pg'
  conn = PGconn.open(:host => APP_CONFIG['db_host'], :port => APP_CONFIG['db_port'], :dbname => APP_CONFIG['db_name'], :user => APP_CONFIG['db_user'], :password => APP_CONFIG['db_pass'])
  return conn
end

require 'pp'

@conn = pg_connect()

ApplicationGroup.complete.where('copied_to_serse = ?',false).each do |ag|
  @conn.transaction {
    @pg_sql = "insert into tbl_application_groups
                        (epoch,name,spouse_complete,children_complete,other_complete,complete,
                         data_protection_consent,data_protection_caux_info,data_protection_local_info,
                         browser,session_group_id,group_registration,family_registration,group_or_family_name,
                         payment_required,payment_received,payment_currency,payment_reference)
                 values (
                   #{ag.updated_at.to_i},
                   '#{@conn.escape(ag.primary_applicant.surname)}, #{@conn.escape(ag.primary_applicant.firstname)}',
                   1,
                   1,
                   1,
                   1,
                   #{ag.data_protection_consent ? '1' : '0'},
                   #{ag.data_protection_caux_info},
                   #{ag.data_protection_local_info},
                   '#{@conn.escape(ag.browser)}',
                   #{ag.session_group_id},
                   #{ag.group_registration},
                   #{ag.family_registration},
                   '#{@conn.escape(ag.group_or_family_name)}',
                   #{ag.payment_required},
                   #{ag.payment_received},
                   '#{@conn.escape(ag.payment_currency)}',
                   '#{@conn.escape(ag.payment_reference)}')"
    @res = @conn.exec(@pg_sql)

    @pg_sql = "select currval('seq_application_groups_id') as currval"
    @res = @conn.exec(@pg_sql)
    @serse_application_group_id = @res[0]['currval']

    ag.online_applications.each do |oa|
      puts oa.firstname
      puts oa.surname

      if oa.relation == 'primary applicant' then
        @application_group_sort = 1
        @relation = 'Primary applicant'
      elsif oa.relation == 'spouse' then
        @application_group_sort = 2
        @relation = 'Spouse'
      elsif oa.relation == 'child' then
        @application_group_sort = 3
        @relation = 'Child'
      elsif oa.relation == 'other' then
        @application_group_sort = 4
        @relation = 'Other'
      else
        STDERR.puts "UNKNOWN relation: #{oa.relation}\n"
        exit(1)
      end

      @keys = '('
      @values = '('

      @keys += 'epoch,'
      @values += "#{oa.updated_at.to_i},"

      @keys += 'application_group_id,'
      @values += "currval('seq_application_groups_id'),"

      @keys += 'application_group_sort,'
      @values += "#{@application_group_sort},"

      @keys += 'relation_to_master,'
      @values += "'" + @conn.escape(@relation) + "',"

      @keys += 'firstname,'
      @values += "'" + @conn.escape(oa.firstname) + "',"

      @keys += 'surname,'
      @values += "'" + @conn.escape(oa.surname) + "',"

      @keys += 'birthdate,'
      @values += "'" + @conn.escape(oa.date_of_birth.strftime("%Y-%m-%d")) + "',"

      @keys += 'gender,'
      @values += "#{oa.gender},"

      if not oa.country.nil? then
        @keys += 'citizenship_id,'
        @values += oa.country.serse_id.to_s + ","
      else
        @keys += 'citizenship_id,'
        @values += "0,"
      end

      @keys += 'other_citizenship,'
      @values += "'" + @conn.escape(oa.other_citizenship) + "',"

      # The form does not prevent duplicate languages from being entered at the moment
      @languages_seen = Hash.new()
      @language_count = 1
      oa.online_application_languages.each do |l|
        next if @languages_seen.has_key?(l.language.serse_id)
        @keys += "language_id#{@language_count},"
        @values += l.language.serse_id.to_s + ","
        @keys += "language_id#{@language_count}_proficiency,"
        @values += l.proficiency.to_s + ","
        @language_count += 1
        @languages_seen[l.language.serse_id] = true
        # We can only store up to 4 languages
        break if @language_count == 4
      end

      @keys += 'profession,'
      @values += "'" + @conn.escape(oa.profession) + "',"

      @keys += 'employer,'
      @values += "'" + @conn.escape(oa.employer) + "',"

      @keys += 'email,'
      @values += "'" + @conn.escape(oa.email) + "',"

      @keys += 'telephone,'
      oa.telephone = '' if oa.telephone.nil?
      @values += "'" + @conn.escape(oa.telephone) + "',"

      @keys += 'cellphone,'
      oa.cellphone = '' if oa.cellphone.nil?
      @values += "'" + @conn.escape(oa.cellphone) + "',"

      @keys += 'fax,'
      oa.fax = '' if oa.fax.nil?
      @values += "'" + @conn.escape(oa.fax) + "',"

      @keys += 'work_phone,'
      oa.work_telephone = '' if oa.work_telephone.nil?
      @values += "'" + @conn.escape(oa.work_telephone) + "',"

      # Spouse/children have no permanent address
      if not oa.permanent_address.nil? then
        @keys += 'street1,'
        @values += "'" + @conn.escape(oa.permanent_address.street1) + "',"

        @keys += 'street2,'
        @values += "'" + @conn.escape(oa.permanent_address.street2) + "',"

        @keys += 'street3,'
        @values += "'" + @conn.escape(oa.permanent_address.street3) + "',"

        @keys += 'city,'
        @values += "'" + @conn.escape(oa.permanent_address.city[0,29]) + "',"

        @keys += 'zipcode,'
        @values += "'" + @conn.escape(oa.permanent_address.postal_code) + "',"

        @keys += 'state,'
        @values += "'" + @conn.escape(oa.permanent_address.state[0,29]) + "',"

        if oa.permanent_address.country_id != 0 then
          @keys += 'country_id,'
          @values += oa.permanent_address.country.serse_id.to_s + ","
        else
          @keys += 'country_id,'
          @values += "0,"
        end

        @keys += 'other_country,'
        @values += "'" + @conn.escape(oa.permanent_address.other_country) + "',"
      end

      @keys += 'arrival,'
      @values += "'" + @conn.escape(oa.arrival.to_date.strftime("%Y-%m-%d")) + "',"

      @keys += 'arrival_time,'
      @values += "'" + @conn.escape(oa.arrival.to_time.strftime("%H:%M")) + "',"

      @keys += 'departure,'
      @values += "'" + @conn.escape(oa.departure.to_date.strftime("%Y-%m-%d")) + "',"

      @keys += 'departure_time,'
      @values += "'" + @conn.escape(oa.departure.to_time.strftime("%H:%M")) + "',"

      @keys += 'travel_car_train,'
      @values += "'',"

      @keys += 'travel_flight,'
      @values += "'',"

      @keys += 'previous_visit,'
      @values += "'" + @conn.escape(oa.previous_visit ? 'yes' : 'no' ) + "',"

      @keys += 'previous_year,'
      @values += "'',"

      @keys += 'heard_about,'
      @values += "'" + @conn.escape(oa.heard_about) + "',"

      @keys += 'other_reasons,'
      @or = ''
      @or = "Other (" + @conn.escape(oa.other_reason_detail) + "), " if oa.other_reason
      @or += "Volunteer (" + @conn.escape(oa.volunteer_detail) + "), " if oa.volunteer
      @or += "Staff (" + @conn.escape(oa.staff_detail) + "), " if oa.staff
      if @or != '' then
        @or.chop!
        @or.chop!
      end
      @values += "'" + @or[0..199] + "',"

      @keys += 'diet,'
      @diets = ''
      oa.diets.each do |d|
        @diets += "#{d.name}, "
      end
      @diets += oa.diet_other_detail + ", " if oa.diet_other_detail
      if @diets != '' then
        @diets.chop!
        @diets.chop!
      end
      @values += "'" + @conn.escape(@diets) + "',"

      @keys += 'confirmation_letter_via,'
      @confirmation_letter_via = oa.confirmation_letter_via
      # family members can have this set to NULL
      @confirmation_letter_via = 'email' if @confirmation_letter_via.nil?
      @values += "'" + @conn.escape(@confirmation_letter_via) + "',"

      @accompanied_by = ''
      if @relation == 'Primary applicant' and ag.online_applications.size == 1 then
        @accompanied_by = 'nobody'
      elsif @relation == 'Primary applicant' and ag.online_applications.size > 1 then
        @children = 0
        @spouse = 0
        @other = 0
        ag.online_applications.each do |oapp|
          if oa.relation == 'primary applicant' then
            # noop
          elsif oa.relation == 'spouse' then
            @spouse += 1
          elsif oa.relation == 'child' then
            @children += 1
          elsif oa.relation == 'other' then
            @other += 1
          end
        end
        @accompanied_by += 'spouse' if @spouse > 0
        @accompanied_by += 'children' if @children > 0
        @accompanied_by += 'other' if @other > 0
      end

      @keys += 'accompanied_by,'
      @values += "'" + @conn.escape(@accompanied_by) +"',"

      @keys += 'visa,'
      @values += "#{oa.visa ? 1 : 0},"

      if oa.visa then
        if oa.visa_reference_name
          @keys += 'reference,'
          @values += "'" + @conn.escape(oa.visa_reference_name) + "',"
        end
        if oa.visa_reference_email
          @keys += 'reference_email,'
          @values += "'" + @conn.escape(oa.visa_reference_email) + "',"
        end
      end

      @keys += 'family_discount,'
      @values += @conn.escape(oa.family_discount ? 'true' : 'false') + ","

      @keys += 'support_renovation_fund,'
      @values += @conn.escape(oa.support_renovation_fund ? 'true' : 'false') + ","

      @keys += 'full_time_volunteer,'
      @values += @conn.escape(oa.full_time_volunteer ? 'true' : 'false') + ","

      @keys += 'day_visit,'
      @values += @conn.escape(oa.day_visit ? 'true' : 'false') + ","

      @keys += 'sent_by_employer,'
      @values += @conn.escape(oa.sent_by_employer ? 'true' : 'false') + ","

      @keys += 'student,'
      @values += @conn.escape(oa.student ? 'true' : 'false') + ","

      @keys += 'interpreter,'
      @values += @conn.escape(oa.interpreter ? 'true' : 'false') + ","

      @keys += 'staff,'
      @values += @conn.escape(oa.staff ? 'true' : 'false') + ","

      @keys += 'volunteer,'
      @values += @conn.escape(oa.volunteer ? 'true' : 'false') + ","

      @keys += 'calculated_registration_fee,'
      @values += oa.calculated_registration_fee.to_s + ","

      @keys += 'calculated_night_rate,'
      @values += oa.calculated_night_rate.to_s + ","

      @keys += 'calculated_nights,'
      @values += oa.calculated_nights.to_s + ","

      @keys += 'calculated_total_personal_contribution,'
      @values += oa.calculated_total_personal_contribution.to_s + ","

      @keys += 'calculated_rate_and_fee_details,'
      if not oa.financial_remarks.nil? and not oa.financial_remarks.empty?
        @values += "'" + @conn.escape(oa.calculated_rate_and_fee_details.to_s) + "\n\n"
        @values += "APPLICANT FINANCIAL REMARKS:\n" + @conn.escape(oa.financial_remarks.to_s) + "',"
      else
        @values += "'" + @conn.escape(oa.calculated_rate_and_fee_details.to_s) + "',"
      end

      @keys += 'currency,'
      @values += "'chf',"

      @sponsor_count = 1
      oa.sponsors.each do |s|
        # Skip invalid sponsor lines; this can happen if a sponsor was put in
        # and the form was submitted, but the sponsor was removed before the
        # application was submitted.
        next if @conn.escape(s.name) == '' or s.amount.nil? or s.nights.nil?
        @keys += "sponsor_#{@sponsor_count},"
        @values += "'" + @conn.escape(s.name) + "',"
        @keys += "sponsor_#{@sponsor_count}_amount,"
        @values += s.amount.to_s + ","
        @keys += "sponsor_#{@sponsor_count}_nights,"
        @values += s.nights.to_s + ","
        @keys += "sponsor_#{@sponsor_count}_currency,"
        @values += "'chf',"
        @sponsor_count += 1
        break if @sponsor_count > 4
      end

      @keys += 'remarks,'
      @values += "'" + @conn.escape(oa.remarks[0,5000]) + "',"

      if oa.visa then
        @keys += 'passport_number,'
        @values += "'" + @conn.escape(oa.passport_number) + "',"

        @keys += 'passport_issue_date,'
        @values += "'" + @conn.escape(oa.passport_issue_date.strftime("%Y-%m-%d")) + "',"

        @keys += 'passport_issue_place,'
        @values += "'" + @conn.escape(oa.passport_issue_place) + "',"

        @keys += 'passport_expiry_date,'
        @values += "'" + @conn.escape(oa.passport_expiry_date.strftime("%Y-%m-%d")) + "',"

        @keys += 'passport_embassy,'
        @values += "'" + @conn.escape(oa.passport_embassy) + "',"
      end

      @keys += 'badge_firstname,'
      @values += "'" + @conn.escape(oa.badge_firstname) + "',"

      @keys += 'badge_surname,'
      @values += "'" + @conn.escape(oa.badge_surname) + "',"

      @keys += 'badge_country,'
      @values += "'" + @conn.escape(oa.badge_country) + "',"

      @keys += 'communications_language_id,'
      if not oa.communications_language.nil?
        @values += "'" + oa.communications_language.serse_id.to_s + "',"
      else
        @values += "'0',"
      end

      @keys.chop!
      @values.chop!

      @keys += ')'
      @values += ')'

      @pg_sql = "insert into tbl_applications #{@keys} values #{@values}"
      STDERR.puts @pg_sql.pretty_inspect()
      @res = @conn.exec(@pg_sql)

      ####################### APPLICATION TRANSLATION NEEDS ################################
      oa.application_translation_needs.each do |t|
        @pg_sql = "insert into application_translation_needs (language_id,online_application_id,updated_at,created_at)
                   values (#{Language.find(t.language_id).serse_id},currval('seq_applications_id'),now(),now())"
        @res = @conn.exec(@pg_sql)
      end

      ####################### SESSIONS ################################
      # my $pg_sql2 = "insert into tbl_application_sessions (session_id,application_id) values ";
      # $pg_sql2 .= "($applications{$key}{sessions}{$key2},currval('seq_applications_id'))";
      oa.conferences.each do |c|
        @pg_sql = "insert into tbl_application_sessions (session_id,application_id)
                     values (#{c.serse_id},currval('seq_applications_id'))"
        @res = @conn.exec(@pg_sql)
      end

      ####################### TRAINING PROGRAMS #######################
      oa.training_programs.each do |tp|
        @pg_sql = "insert into tbl_application_training_programs (training_program_id,application_id)
                     values (#{tp.serse_id},currval('seq_applications_id'))"
        @res = @conn.exec(@pg_sql)
      end

      ####################### SESSION VARIABLES #######################
      oa.online_application_conferences.each do |oac|
        @pg_sql = "insert into online_application_conferences (online_application_id,conference_id,selected,variables,priority_sort,role_participant,role_speaker,role_team)
                     values (currval('seq_applications_id'),#{oac.conference.serse_id},#{oac.selected},$1,#{oac.priority_sort},#{oac.role_participant ? true : false },#{oac.role_speaker ? true : false },#{oac.role_team ? true : false})"
        @res = @conn.exec(@pg_sql,[oac.attributes_before_type_cast["variables"].to_yaml])

        oac.online_application_conference_workstreams.each do |ws|
          # team members need not select a workstream preference. If they do not (ws.conference_workstream_id is null) then do not try to insert the record
          next if ws.conference_workstream_id.nil?
          # if a workstream no longer exists, just skip it. This catches a race condition
          # where the workstream has been removed from Serse but the form still has it
          # (the cron job updating the form has not run yet, or the application was filled
          # out in the past and only just now submitted)
          next if ws.conference_workstream.nil?
          @pg_sql = "insert into online_application_conference_workstreams (online_application_conference_id,conference_workstream_id,preference) values " +
                    "(currval('online_application_conferences_id_seq'),#{ws.conference_workstream.serse_id},#{ws.preference == 'first_choice' ? 1 : 2})"
          @res = @conn.exec(@pg_sql)
        end
      end

      # Mark this application as copied to Serse
      ag.reload
      ag.copied_to_serse = true
      ag.serse_application_group_id = @serse_application_group_id.to_i
      ag.save!
    end
  }


end
