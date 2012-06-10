#!/usr/bin/env ruby

# THIS SCRIPT NEEDS TO BE RUN IN FLOCK #

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def pg_connect
	require 'pg'
	conn = PGconn.open(:host => '127.0.0.1', :port => '5432', :dbname => 'serse', :user => '***REMOVED***', :password => '***REMOVED***')
	return conn
end

require 'pp'

@conn = pg_connect()

ApplicationGroup.complete.where('copied_to_serse = ?',false).each do |ag|
	@conn.transaction {
	  @pg_sql = "insert into tbl_application_groups 
  	                    (epoch,name,spouse_complete,children_complete,other_complete,complete,
	                       data_protection_consent,data_protection_caux_info,data_protection_local_info,browser,session_group_id) 
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
	                 #{ag.session_group_id})"
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
				STDERR.puts "UNKNOWN relantion: #{oa.relation}\n"
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
			end

			@keys += 'profession,'
			@values += "'" + @conn.escape(oa.profession) + "',"

			@keys += 'employer,'
			@values += "'" + @conn.escape(oa.employer) + "',"

			@keys += 'email,'
			@values += "'" + @conn.escape(oa.email) + "',"

			@keys += 'telephone,'
			@values += "'" + @conn.escape(oa.telephone) + "',"

			@keys += 'cellphone,'
			@values += "'" + @conn.escape(oa.cellphone) + "',"

			@keys += 'fax,'
			@values += "'" + @conn.escape(oa.fax) + "',"

			@keys += 'work_phone,'
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
			@values += "'" + @conn.escape(oa.travel_car_train) + "',"

			@keys += 'travel_flight,'
			@values += "'" + @conn.escape(oa.travel_flight) + "',"

			@keys += 'previous_visit,'
			@values += "'" + @conn.escape(oa.previous_visit ? 'yes' : 'no' ) + "',"

			@keys += 'previous_year,'
			@values += "'" + @conn.escape(oa.previous_year) + "',"

			@keys += 'heard_about,'
			@values += "'" + @conn.escape(oa.heard_about) + "',"

			@keys += 'other_reasons,'
			@values += "'" + @conn.escape(oa.other_reason_detail) + "',"

			@keys += 'diet,'
			@diets = ''
			oa.diets.each do |d|
				@diets += "#{d.name}, "
			end
			if @diets != '' then
				@diets.chop!
				@diets.chop!
			end
			@values += "'" + @conn.escape(@diets) + "',"

			@keys += 'confirmation_letter_via,'
			@confirmation_letter_via = oa.confirmation_letter_via
			@confirmation_letter_via = 'postdifferent' if @confirmation_letter_via == 'correspondence_address'
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
				@keys += 'reference,'
				@values += "'" + @conn.escape(oa.visa_reference_name) + "',"
				@keys += 'reference_email,'
				@values += "'" + @conn.escape(oa.visa_reference_email) + "',"
			end

			@keys += 'financial_contribution,'
			@values += oa.nightly_contribution.to_s + ","

			@keys += 'currency,'
			@values += "'chf',"

			@sponsor_count = 1
			oa.sponsors.each do |s|
				@keys += "sponsor_#{@sponsor_count},"
				@values += "'" + @conn.escape(s.name) + "',"
				@keys += "sponsor_#{@sponsor_count}_amount,"
				@values += s.amount.to_s + ","
				@keys += "sponsor_#{@sponsor_count}_nights,"
				@values += s.nights.to_s + ","
				@keys += "sponsor_#{@sponsor_count}_currency,"
				@values += "'chf',"
				@sponsor_count += 1
			end

			@keys += 'remarks,'
			@values += "'" + @conn.escape(oa.remarks) + "',"

			if not oa.correspondence_address.nil? then
  			@keys += 'correspondence_street1,'
  			@values += "'" + @conn.escape(oa.correspondence_address.street1) + "',"
  
  			@keys += 'correspondence_street2,'
  			@values += "'" + @conn.escape(oa.correspondence_address.street2) + "',"
  
  			@keys += 'correspondence_street3,'
  			@values += "'" + @conn.escape(oa.correspondence_address.street3) + "',"
  
  			@keys += 'correspondence_city,'
  			@values += "'" + @conn.escape(oa.correspondence_address.city) + "',"
  
  			@keys += 'correspondence_zipcode,'
  			@values += "'" + @conn.escape(oa.correspondence_address.postal_code) + "',"
  
  			@keys += 'correspondence_state,'
  			@values += "'" + @conn.escape(oa.correspondence_address.state) + "',"
  
  			if oa.correspondence_address.country_id != 0 then
  				@keys += 'correspondence_country_id,'
  				@values += "'" + oa.correspondence_address.country.serse_id.to_s + "',"
  			else
  				@keys += 'correspondence_country_id,'
  				@values += "'" + oa.correspondence_address.country_id.to_s + "',"
  			end
  
  			@keys += 'correspondence_other_country,'
  			@values += "'" + @conn.escape(oa.correspondence_address.other_country) + "',"
  
  			@keys += 'correspondence_valid_from,'
  			@values += "'" + @conn.escape(oa.correspondence_address.valid_from.strftime("%Y-%m-%d")) + "',"

  			@keys += 'correspondence_valid_until,'
  			@values += "'" + @conn.escape(oa.correspondence_address.valid_until.strftime("%Y-%m-%d")) + "',"
      end
  
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

			@keys.chop!
			@values.chop!

			@keys += ')'
			@values += ')'

			@pg_sql = "insert into tbl_applications #{@keys} values #{@values}"

      STDERR.puts @pg_sql.pretty_inspect()
		  @res = @conn.exec(@pg_sql)

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
					# TODO: once #202 is done, this will need to refer to the serse_id value in the conference_workstreams table!
          @pg_sql = "insert into online_application_conference_workstreams (online_application_conference_id,conference_workstream_id,preference) values " +
                    "(currval('online_application_conferences_id_seq'),#{ws.conference_workstream.serse_id},#{ws.preference == 'first_choice' ? 1 : 2})"
		  		@res = @conn.exec(@pg_sql)
				end
			end

			# Mark this application as copied to Serse
			ag.copied_to_serse = true
			ag.serse_application_group_id = @serse_application_group_id.to_i
			ag.save!

		end	
	}


end
