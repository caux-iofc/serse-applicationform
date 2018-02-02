class OnlineApplications::BuildController < ApplicationController

  before_filter :ensure_application_group

  include Wicked::Wizard
  steps :personal, :group, :family, :detail, :dates_and_events, :visa, :finances, :confirmation, :payment

  def show
    @step = step
    if step.to_s != 'wicked_finish'
      # Make sure that we're not skipping steps!
      redirstep = step
      while (steps.index(redirstep) - 1) >= 0
        if not has_completed?(steps[steps.index(redirstep) - 1])
          redirstep = steps[steps.index(redirstep) - 1]
        else
          break
        end
      end
      if redirstep != step
        redirect_to wizard_path(redirstep)
        return
      end

      # Catch people using the back button from the 'Registration form complete' page
      if @online_application.status.nil? and step != :personal and step != :complete
        redirect_to wizard_path(steps.first)
        return
      end
    end

    # Make sure the single/family/group radio button is prepopulated
    if @online_application.application_group.group_registration
      @online_application.registration_type = 'group'
    elsif @online_application.application_group.family_registration
      @online_application.registration_type = 'family'
    else
      @online_application.registration_type = 'single'
    end

    if step == :group or step == :family or step == :detail or step == :dates_and_events or step == :visa or step == :finances or step == :confirmation
      # Because we use the @application_group object for these steps, we need to
      # make sure to explicitly update the status field which lives on the primary
      # applicant object.
      @online_application.status = step.to_s
      @online_application.save(:validate => false)
    end

    populate_ethereal_variables
    render_wizard
  end

  def add_family_member
    add_member
    @application_group.online_applications.build()
    render "add_family_member", :layout => false
  end

  def add_group_member
    add_member
    # The form allows setting an alternative permament address for group members
    @application_group.online_applications.build({:relation => 'other'})
    @application_group.online_applications.first.build_permanent_address if @application_group.online_applications.first.permanent_address.nil?
    render "add_group_member", :layout => false
  end

  def update
    if not @application_group.online_applications.include?(@online_application) then
      # Something funky is going on here. Most likely, they have already submitted this application.
      redirect_to :error
      return
    end

    # This is effectively optimistic locking. Deals with people who open multiple copies of the form in various
    # stages on different browser tabs and then submit them interchangeably. Yes, this is pretty common.
    if ((params.has_key?('application_group') and
         params[:application_group].has_key?('lock_version') and
         params[:application_group][:lock_version] != @application_group.lock_version.to_s) or
        (params.has_key?('online_application') and
         params[:online_application].has_key?('lock_version') and
        params[:online_application][:lock_version] != @online_application.lock_version.to_s))
      # This is not the latest copy of the application group. Tell the user and reload the page.
      flash[:error] = "The application was modified since this page was loaded. The changes you just submitted could not be saved. Please try again."
      redirect_to request.path
      return
    else
      params[:application_group].delete('lock_version') if params.has_key?('application_group') and params[:application_group].has_key?('lock_version')
      params[:online_application].delete('lock_version') if params.has_key?('online_application') and params[:online_application].has_key?('lock_version')
    end

    if step != :group and step != :family and step != :detail and step != :dates_and_events and step != :visa and step != :finances and step != :confirmation and step != :payment
      @online_application.the_request = request

      params[:online_application][:status] = step.to_s
      params[:online_application][:status] = 'complete' if step == steps.last

      if not @online_application.update_attributes(params[:online_application])
        populate_ethereal_variables
      else
        if step == :personal and @online_application.relation == 'primary applicant'
          @online_application.application_group.group_registration = (@online_application.registration_type == 'group' ? true : false)
          @online_application.application_group.family_registration = (@online_application.registration_type == 'family' ? true: false)
          # We can't validate the group here yet, because the group name is probably not set yet.
          # We can't make the group name validation conditional on the step of this form
          # because we need to consult the primary application online_application for the step
          # and that record is not accessible yet when the applcation_group object is being validated.
          # It would be, if inverse_of worked for has_many, which it does not (as of rails 3.2.21)...
          @online_application.application_group.save(:validate => false)
        end
      end
    else
      if step == :finances
        # The rate radio button should set the student boolean to true if that rate is selected
        params[:application_group]['online_applications_attributes'].each do |key,val|
          if val['rate'] == 'student'
            val['student'] = 1
          else
            val['student'] = 0
          end
        end
        params[:application_group][:online_applications_attributes].each do |k,v|
          if params[:application_group][:payment_required].nil? then
            params[:application_group][:payment_required] = 0
          end
          params[:application_group][:payment_required] += v[:calculated_registration_fee].to_i
        end
      end
      if step == :group and params[:application_group].has_key?('online_applications_attributes')
        # Do not save permanent address information if the 'different address' checkbox is not set
        params[:application_group]['online_applications_attributes'].each do |key,val|
          val['permanent_address_attributes']['_destroy'] = true if val['different_address'] != '1'
        end
      end
      if step == :dates_and_events
        if params[:application_group][:online_applications_attributes]['0']['heard_about'] == 'I have been to Caux before'
          params[:application_group][:online_applications_attributes]['0']['previous_visit'] = true
        end

        params[:application_group][:online_applications_attributes].each do |k,v|

          # If no check boxes are checked, the form does not return those fields.
          # Handle that here, making sure that any training programs previously
          # selected will be removed.
          if params[:application_group][:online_applications_attributes][k].has_key?('online_application_training_programs_attributes')
            params[:application_group][:online_applications_attributes][k]['online_application_training_programs_attributes'].each do |k2,v2|
              if v2['selected'] != '1'
                v2['_destroy'] = true
              elsif v2 and not v2.has_key?('id') and params[:application_group][:online_applications_attributes][k].has_key?('id')
                # It turns out that update_attributes (below) does not add *new* online_application_training_programs,
                # if the online application already has some online_application_training_programs (i.e. when the user came back
                # to the 'Stay in Caux' page after having saved it and added a new training_program. So, we add these explicitly
                # here, and then set the id field to make update_attributes do an additional refresh of the
                # application_group object.
                oatp = OnlineApplicationTrainingProgram.new(v2)
                oatp.online_application_id = params[:application_group][:online_applications_attributes][k]['id']
                # Save but guard against race conditions (or double form submissions, Edge seems to have a knack for those)
                begin
                  oatp.save
                  v2['id'] = oatp.id
                rescue
                  v2['id'] = OnlineApplicationTrainingProgram.where(:online_application_id => params[:application_group][:online_applications_attributes][k]['id'], :training_program_id => v2[:training_program_id]).first.id
                end
              end
            end
          end
          # Make sure we delete online_application_conferences records that are not selected
          if params[:application_group][:online_applications_attributes][k].has_key?('online_application_conferences_attributes')
            params[:application_group][:online_applications_attributes][k]['online_application_conferences_attributes'].each do |k2,v2|
              if v2['selected'] != '1'
                v2['_destroy'] = true
              elsif v2 and not v2.has_key?('id') and params[:application_group][:online_applications_attributes][k].has_key?('id')
                # It turns out that update_attributes (below) does not add *new* online_application_conferences,
                # if the online application already has some online_application_conferences (i.e. when the user came back
                # to the 'Stay in Caux' page after having saved it and added a new conference. So, we add these explicitly
                # here, and then set the id field to make update_attributes do an additional refresh of the
                # application_group object.
                oac = OnlineApplicationConference.new(v2)
                oac.online_application_id = params[:application_group][:online_applications_attributes][k]['id']
                # Save but guard against race conditions (or double form submissions, Edge seems to have a knack for those)
                begin
                  oac.save
                  v2['id'] = oac.id
                rescue
                  v2['id'] = OnlineApplicationConference.where(:online_application_id => params[:application_group][:online_applications_attributes][k]['id'], :conference_id => v2[:conference_id]).first.id
                end
              end
            end
          end

          # Save the 'stay in caux' information for every participant in the group
          next if k == '0'
          params[:application_group][:online_applications_attributes][k]['day_visit'] = params[:application_group][:online_applications_attributes]['0']['day_visit']
          params[:application_group][:online_applications_attributes][k]['arrival(1i)'] = params[:application_group][:online_applications_attributes]['0']['arrival(1i)']
          params[:application_group][:online_applications_attributes][k]['arrival(2i)'] = params[:application_group][:online_applications_attributes]['0']['arrival(2i)']
          params[:application_group][:online_applications_attributes][k]['arrival(3i)'] = params[:application_group][:online_applications_attributes]['0']['arrival(3i)']
          params[:application_group][:online_applications_attributes][k]['arrival(4i)'] = params[:application_group][:online_applications_attributes]['0']['arrival(4i)']
          params[:application_group][:online_applications_attributes][k]['arrival(5i)'] = params[:application_group][:online_applications_attributes]['0']['arrival(5i)']
          params[:application_group][:online_applications_attributes][k]['departure(1i)'] = params[:application_group][:online_applications_attributes]['0']['departure(1i)']
          params[:application_group][:online_applications_attributes][k]['departure(2i)'] = params[:application_group][:online_applications_attributes]['0']['departure(2i)']
          params[:application_group][:online_applications_attributes][k]['departure(3i)'] = params[:application_group][:online_applications_attributes]['0']['departure(3i)']
          params[:application_group][:online_applications_attributes][k]['departure(4i)'] = params[:application_group][:online_applications_attributes]['0']['departure(4i)']
          params[:application_group][:online_applications_attributes][k]['departure(5i)'] = params[:application_group][:online_applications_attributes]['0']['departure(5i)']
          params[:application_group][:online_applications_attributes][k]['previous_visit'] = params[:application_group][:online_applications_attributes]['0']['previous_visit']
          params[:application_group][:online_applications_attributes][k]['heard_about'] = params[:application_group][:online_applications_attributes]['0']['heard_about']
        end
      end

      if step == :confirmation
        # As of 2016, we now do a single opt out for newletters on the confirmation page.
        # Turn that into the correct value for the caux and local opt in fields here.
        if params[:application_group][:no_newsletters]
          params[:application_group].delete('no_newsletters')
          @application_group.data_protection_caux_info = false
          @application_group.data_protection_local_info = false
        else
          @application_group.data_protection_caux_info = true
          @application_group.data_protection_local_info = true
        end
      end

      if not @application_group.update_attributes(params[:application_group])
        # We can't use render_wizard directly here, because @online_application validates fine,
        # but this step is tied to the validation of application_group. Yes, we're doing silly
        # things here.
        if step != :group and step != :family and step != :detail and step != :finances
          # Apply the changes, but don't save (because validation fails).
          # Don't do this on the group step, because we'll duplicate new group members otherwise.
          @application_group.assign_attributes(params[:application_group])
        end
        show
        return
      elsif step == :confirmation
        if @application_group.payment_required == 0 or session[:skip_payment] or PAYMENT_STEP_DISABLED then
          # No payment required, skip to the end!
          complete_application_group
          redirect_to build_path(Wicked::FINISH_STEP)
          return
        end
      elsif step == :payment
        # We're done, but just in case, see if payment is still required
        if @application_group.payment_required != @application_group.payment_received then
          # Hrm, still need money. Redirect them to the payment step.
          redirect_to build_path(:payment)
          return
        else
          complete_application_group
        end
      end
      # reload @online_application, we've changed it by updating @application_group
      @online_application = OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first
    end

    render_wizard @online_application
  end

  def complete_application_group
    @application_group.complete = true
    @application_group.save
    if @application_group.primary_applicant and @application_group.primary_applicant.email
      SystemMailer.notice_of_receipt("#{@application_group.primary_applicant.pretty_name} <#{@application_group.primary_applicant.email}>").deliver
    end
  end

  # We use this method to reset the application
  def new
    redirect_to wizard_path(steps.first, :online_application_id => @online_application.id)
  end

  # GET /build
  # GET /online_applications.json
  def index
    @online_applications = OnlineApplication.where(:application_group_id => @application_group.id)
    if @online_applications.size == 0 or @application_group.complete
      redirect_to new_build_path
      return
    elsif not @online_application.nil? and @online_application.status.nil?
      redirect_to wizard_path(steps.first, :online_application_id => @online_application.id)
      return
    elsif not @online_application.nil? and not @online_application.status.nil? and
          not @online_application.status.empty? and @online_application.status != 'complete' and
          not steps.index(@online_application.status.to_sym).nil? then
      redirect_to wizard_path(steps[steps.index(@online_application.status.to_sym)], :online_application_id => @online_application.id)
      return
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

protected

  def finish_wizard_path
    application_group_submitted_path
  end

  def populate_ethereal_variables
    calculate_progress_bar

    # used to auto-populate the earliest start year and latest stop year
    # in the arrival/departure dropdowns
    @earliest_start_year = Time.now.year
    @latest_stop_year = Time.now.year

    # Make sure we have three sponsor lines; the first two are
    # auto-calculated (and empty if not needed)
    @application_group.online_applications.each do |oa|
      @size = oa.sponsors.auto.size
      while @size < 2 do
        oa.sponsors.build({:auto => true})
        @size += 1
      end
      @size = oa.sponsors.not_auto.size
      while @size < 1 do
        oa.sponsors.build({:auto => false})
        @size += 1
      end
    end

    # Make sure we have at least four online_application_language lines for each
    # applicant in the group
    @application_group.online_applications.each do |oa|
      @size = oa.online_application_languages.size
      while @size < 4 do
        oa.online_application_languages.build()
        @size += 1
      end
    end

    @application_group.online_applications.each do |oa|
      @conferences = Hash.new()
      oa.online_application_conferences.each_with_object({}) {|oac| @conferences[oac.conference_id]=oac.conference_id }
      @priority_sort = 0
      Conference.normal.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
        @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
        @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
        if not @conferences.has_key?(c.id) then
          @oac = oa.online_application_conferences.build({:conference_id => c.id, :priority_sort => @priority_sort += 1 })
          @oac.variables[:role] = 'participant'
        end
      end

      Conference.special.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
        @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
        @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
        if not @conferences.has_key?(c.id) then
          @oac = oa.online_application_conferences.build({:conference_id => c.id, :priority_sort => @priority_sort += 1 })
          @oac.variables[:role] = 'participant'
        end
      end

      Conference.caux_forum_training.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
        @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
        @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
        if not @conferences.has_key?(c.id) then
          @oac = oa.online_application_conferences.build({:conference_id => c.id, :priority_sort => @priority_sort += 1 })
          @oac.variables[:role] = 'participant'
          # The user can choose a workstream
          @oac.online_application_conference_workstreams.build({ :preference => 'preference' })
        end
      end

      @training_programs = Hash.new()
      oa.online_application_training_programs.each_with_object({}) {|oatp| @training_programs[oatp.training_program_id]=oatp.training_program_id }
      @priority_sort = 0
      TrainingProgram.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
        @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
        @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
        if not @training_programs.has_key?(c.id) then
          @oatp = oa.online_application_training_programs.build({:training_program_id => c.id })
        end
      end

    end

    @languages = Language.all.collect {|p| [ p.name, p.id ] }.select { |x| !x[0].nil? }.sort { |a,b| a[0] <=> b[0] }
    @language_proficiencies = [ [t('proficiency_poor'),'110'], [t('proficiency_good'),'120'], [t('proficiency_excellent'),'130'], [t('proficiency_native'),'140'] ]

    # Only English, French, German are currently offered
    @old_locale = I18n.locale
    @communications_languages = []
    I18n.locale = 'en'
    @communications_languages << Language.where("serse_id = 63").collect {|p| [ p.name, p.id ] }.flatten!
    I18n.locale = 'fr'
    @communications_languages << Language.where("serse_id = 74").collect {|p| [ p.name, p.id ] }.flatten!
    I18n.locale = 'de'
    @communications_languages << Language.where("serse_id = 89").collect {|p| [ p.name, p.id ] }.flatten!
    @communications_languages.sort!
    I18n.locale = @old_locale

    @diets = @online_application.diets.collect { |d| d.id }

    @countries = [ [t(:other_please_specify),'0'] ] + Country.all.sort { |a,b| a.name <=> b.name }.collect {|p| [ p.name, p.id ] }

    if step == :confirmation
      # Just default (force) the info fields to 'yes'. This is sneaky, but
      # there's no good way to tell if they have never been set: after one failed
      # validation they are no longer nil...
      @application_group.data_protection_caux_info = true
      @application_group.data_protection_local_info = true
    end

    if step == :group or step == :family or step == :confirmation
      # this page needs to store a few fields on the application group object
      @show_ag_errors = true
      if step == :group or step == :family or step == :confirmation
        @show_only_ag_errors = true
      else
        @show_only_ag_errors = false
      end
    else
      @show_ag_errors = false
    end

    if step == :group
      # The form allows setting an alternative permament address for group members
      @application_group.online_applications.each do |oa|
        oa.build_permanent_address if oa.permanent_address.nil?
      end
    end

    if step == :finances
      @application_group.online_applications.each do |oa|
        oa.conference_team = (oa.online_application_conferences.collect { |oac| oac.variables[:role] }.include?('team') ? true : false)
        oa.conference_support = (oa.online_application_conferences.collect { |oac| oac.variables[:role] }.include?('support') ? true : false)
        if oa.rate.nil?
          oa.rate = 'staff' if oa.staff
          oa.rate = 'volunteer' if oa.volunteer
          oa.rate = 'interpreter' if oa.interpreter
          oa.rate = 'conference_team' if oa.conference_team
          oa.rate = 'conference_support' if oa.conference_support
          oa.rate = 'family' if @application_group.family_registration
        end
        # these fields are used to pass information to the javascript that calculates the rates
        oa.caux_scholar = (oa.training_programs.collect { |tp| tp.name }.include?('Caux Scholars Program') ? 1 : 0)
        oa.caux_intern = ((oa.training_programs.collect { |tp| tp.name }.grep(/^Caux Peace and Leadership Programme/)).empty? ? 0 : 1)
        oa.caux_artist = (oa.training_programs.collect { |tp| tp.name }.include?('Caux Artists Program') ? 1 : 0)
        oa.week_of_international_community = (oa.training_programs.collect { |tp| tp.name }.include?('Week of International Community') ? 1 : 0)
        oa.global_assembly = (oa.conferences.collect { |tp| tp.name }.include?('IofC Global Assembly') ? 1 : 0)
        oa.caux_forum_training = ( oa.conferences.caux_forum_training.empty? ? 0 : 1)
        # Default to the standard rate
        oa.rate = 'standard' if oa.rate.nil?
      end
    end

    if step == :dates_and_events
      @heard_about = [
        [t(:choose_one),""],
        [t(:i_have_been_to_caux_before),"I have been to Caux before"],
        [t(:online_search),"Online search"],
        [t(:caux_iofc_website),"CAUX-IofC website"],
        [t(:social_media),"Social Media"],
        [t(:family_friends),"Family/friends"],
        [t(:iofc_network_events),"IofC Network/IofC Events"],
        [t(:other_media),"Other media"],
      ]
    end
  end

  def calculate_progress_bar
    if not wizard_steps.index(step).nil?
      if not @online_application.application_group.group_registration and not @online_application.application_group.family_registration
        if step == :group or step == :family
          skip_step
        end
        @progress_bar_total_steps = wizard_steps.size - 2
        if wizard_steps.index(step) <= wizard_steps.index(:family)
          @progress_bar_current_step = wizard_steps.index(step) + 1
        else
          @progress_bar_current_step = wizard_steps.index(step) - 1
        end
      elsif @online_application.application_group.group_registration
        if step == :family
          skip_step
        end
        @progress_bar_total_steps = wizard_steps.size - 1
        if wizard_steps.index(step) <= wizard_steps.index(:group)
          @progress_bar_current_step = wizard_steps.index(step) + 1
        else
          @progress_bar_current_step = wizard_steps.index(step)
        end
      elsif @online_application.application_group.family_registration
        if step == :group
          skip_step
        end
        @progress_bar_total_steps = wizard_steps.size - 1
        if wizard_steps.index(step) < wizard_steps.index(:family)
          @progress_bar_current_step = wizard_steps.index(step) + 1
        else
          @progress_bar_current_step = wizard_steps.index(step)
        end
      else
        @progress_bar_total_steps = wizard_steps.size - 1
        @progress_bar_current_step = wizard_steps.index(step) + 1
      end
      @progress_bar_with = (@progress_bar_current_step/@progress_bar_total_steps.to_f*100).round
    end
  end

  def add_member
    @count = @application_group.online_applications.count + 1
    # Yeah, this is weird.
    @application_group = ApplicationGroup.new()
    populate_ethereal_variables
  end

private

  def has_completed?(step)
    case step
    when :personal
      not @online_application.surname.nil?
    when :family
      if not @application_group.family_registration
        true
      else
        not @application_group.group_or_family_name.empty?
      end
    when :group
      if not @application_group.group_registration
        true
      else
        not @application_group.group_or_family_name.empty?
      end
    when :detail
      @online_application.communications_language_id != 0
    when :dates_and_events
      not @online_application.arrival.nil?
    when :visa
      not @online_application.visa.nil?
    when :finances
      not @online_application.financial_remarks.nil?
    when :confirmation
      not @application_group.confirm_read_documents.nil? and @application_group.confirm_read_documents
    when :payment
      not @application_group.confirm_read_documents.nil? and @application_group.confirm_read_documents and
        @application_group.payment_required == @application_group.payment_received
    else
      false
    end
  end

end
