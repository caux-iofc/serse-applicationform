class OnlineApplications::BuildController < ApplicationController

  before_filter :ensure_application_group

  include Wicked::Wizard
  steps :personal, :group, :family, :detail, :dates_and_events, :visa, :finances, :confirmation

  def show
    @step = step

    if step != :wicked_finish and step != 'wicked_finish'
      # Catch people using the back button from the 'Registration form complete' page
      if @online_application.status.nil? and step != :personal and step != :complete
        redirect_to wizard_path(steps.first)
        return
      end
   end
    # Add a blank address for correspondence address if it is nil
    # The correspondence address can be nil if it was not required on the
    # previous edit/creation of the online application.  It has to exist if we want it to
    # show up in the form if it becomes needed.
    @online_application.build_correspondence_address if @online_application.correspondence_address.nil?

    # Make sure the single/family/group radio button is prepopulated
    if @online_application.application_group.group_registration
      @online_application.registration_type = 'group'
    elsif @online_application.application_group.family_registration
      @online_application.registration_type = 'family'
    else
      @online_application.registration_type = 'single'
    end

    if step == :group or step == :family or step == :detail or step == :dates_and_events or step == :visa or step == :confirmation
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
    if step != :group and step != :family and step != :detail and step != :dates_and_events and step != :visa and step != :confirmation and step != :finances
      @online_application.the_request = request

      params[:online_application][:status] = step.to_s
      params[:online_application][:status] = 'complete' if step == steps.last

      if not @online_application.update_attributes(params[:online_application])
        @online_application.build_correspondence_address if @online_application.correspondence_address.nil?
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
      end
      if step == :group and params[:application_group].has_key?('online_applications_attributes')
        # Do not save permanent address information if the 'different address' checkbox is not set
        params[:application_group]['online_applications_attributes'].each do |key,val|
          val['permanent_address_attributes']['_destroy'] = true if val['different_address'] != '1'
        end
      end
      if step == :dates_and_events
        params[:application_group][:online_applications_attributes].each do |k,v|

          # If no check boxes are checked, the form does not return those fields.
          # Handle that here, making sure that any training programs previously
          # selected will be removed.
          if not params[:application_group][:online_applications_attributes][k].has_key?('training_program_ids') then
            params[:application_group][:online_applications_attributes][k]['training_program_ids'] = []
          end

          # Make sure we delete online_application_conferences records that are not selected
          if params[:application_group][:online_applications_attributes][k].has_key?('online_application_conferences_attributes')
            params[:application_group][:online_applications_attributes][k]['online_application_conferences_attributes'].each do |k,v|
              v['_destroy'] = true if v['selected'] != '1'
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
          params[:application_group][:online_applications_attributes][k]['travel_car_train'] = params[:application_group][:online_applications_attributes]['0']['travel_car_train']
          params[:application_group][:online_applications_attributes][k]['travel_flight'] = params[:application_group][:online_applications_attributes]['0']['travel_flight']
          params[:application_group][:online_applications_attributes][k]['previous_year'] = params[:application_group][:online_applications_attributes]['0']['previous_year']
          params[:application_group][:online_applications_attributes][k]['heard_about'] = params[:application_group][:online_applications_attributes]['0']['heard_about']
        end
      end
      if not @application_group.update_attributes(params[:application_group])
        # We can't use render_wizard directly here, because @online_application validates fine,
        # but this step is tied to the validation of application_group. Yes, we're doing silly
        # things here.
        populate_ethereal_variables
        show
        return
      elsif step == :confirmation
        # We're done
        @application_group.complete = true
        @application_group.save
      end
      # reload @online_application, we've changed it by updating @application_group
      @online_application = OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first
    end

    render_wizard @online_application
  end

  # We use this method to reset the application
  def new
    redirect_to wizard_path(steps.first, :online_application_id => @online_application.id)
  end

  # GET /build
  # GET /online_applications.json
  def index
    @online_applications = OnlineApplication.find_all_by_application_group_id(@application_group.id)
    if @online_applications.size == 0 or @application_group.complete or @online_application.status == 'confirmation'
      redirect_to new_build_path
      return
    elsif not @online_application.nil? and @online_application.status.nil?
      redirect_to wizard_path(steps.first, :online_application_id => @online_application.id)
      return
    elsif not @online_application.nil? and not @online_application.status.nil? and
          not @online_application.status.empty? and @online_application.status != 'complete' and
          not steps.index(@online_application.status.to_sym).nil? then
      redirect_to wizard_path(steps[steps.index(@online_application.status.to_sym)+1], :online_application_id => @online_application.id)
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

    # Make sure we have four sponsor lines; the first two are
    # auto-calculated (and empty if not needed)
    @application_group.online_applications.each do |oa|
      @count = oa.sponsors.auto.count
      while @count < 2 do
        oa.sponsors.build({:auto => true})
        @count += 1
      end
      @count = oa.sponsors.not_auto.count
      while @count < 2 do
        oa.sponsors.build({:auto => false})
        @count += 1
      end
    end

    # Make sure we have at least four online_application_language lines for each
    # applicant in the group
    @application_group.online_applications.each do |oa|
      while oa.online_application_languages.size < 4 do
        oa.online_application_languages.build
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
          # The user can choose 2 workstreams: a first choice and a second choice
          @oac.online_application_conference_workstreams.build({ :preference => 'first_choice' })
          @oac.online_application_conference_workstreams.build({ :preference => 'second_choice' })
        end
      end

      Conference.special.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
        @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
        @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
        if not @conferences.has_key?(c.id) then
          @oac = oa.online_application_conferences.build({:conference_id => c.id, :priority_sort => @priority_sort += 1 })
        end
      end
    end

    @languages = Language.with_translations.collect {|p| [ p.name, p.id ] }.sort
    @language_proficiencies = [ [t('proficiency_poor'),'110'], [t('proficiency_good'),'120'], [t('proficiency_excellent'),'130'], [t('proficiency_native'),'140'] ]

    @diets = @online_application.diets.collect { |d| d.id }

    @countries = [ [t(:other_please_specify),'0'] ] + Country.with_translations.sort { |a,b| a.name <=> b.name }.collect {|p| [ p.name, p.id ] }

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
        if oa.rate.nil?
          oa.rate = 'staff' if oa.staff
          oa.rate = 'volunteer' if oa.volunteer
          oa.rate = 'interpreter' if oa.interpreter
          oa.rate = 'family' if @application_group.family_registration
        end
        # these fields are used to pass information to the javascript that calculates the rates
        oa.caux_scholar = (oa.training_programs.collect { |tp| tp.name }.include?('Caux Scholars Program') ? 1 : 0)
        oa.caux_intern = ((oa.training_programs.collect { |tp| tp.name }.grep /^Caux Interns Program/).empty? ? 0 : 1)
        oa.caux_artist = (oa.training_programs.collect { |tp| tp.name }.include?('Caux Artists Program') ? 1 : 0)
        oa.week_of_international_community = (oa.training_programs.collect { |tp| tp.name }.include?('Week of International Community') ? 1 : 0)
        oa.conference_team = (oa.online_application_conferences.collect { |oac| oac.role_team }.include?(true) ? 1 : 0)
        oa.conference_speaker = (oa.online_application_conferences.collect { |oac| oac.role_speaker }.include?(true) ? 1 : 0)
        # Default to the standard rate
        oa.rate = 'standard' if oa.rate.nil?
      end
    end
  end

  def ensure_application_group
    # Allow selection of a application, if the session id matches
    if not session.nil? and params[:online_application_id]
      @online_application = OnlineApplication.where(:id => params[:online_application_id], :session_id => request.session_options[:id]).first
      if not @online_application.nil?
        session[:online_application_id] = @online_application.id
        session[:application_group_id] = @online_application.application_group.id
      else
        STDERR.puts "******* Breakin attempt ********"
        STDERR.puts "Tried to access application with id #{params[:online_application_id]} with"
        STDERR.puts "session id #{request.session_options[:id]}, which does not match the session"
        STDERR.puts "saved in the online application record."
        require 'pp'
        STDERR.puts ""
        STDERR.puts "Request information:"
        STDERR.puts request.pretty_inspect()
        STDERR.puts "******* /Breakin attempt ********"
        reset_session
        redirect_to :home
        return
      end
    end

    if not session.nil? and
       session.has_key?(:application_group_id) and
       session.has_key?(:online_application_id)

      @application_group = ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first
      @online_application = OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first
      if @online_application.application_group.id != @application_group.id or
        not @application_group.online_applications.include?(@online_application)
        # Mismatch between application group and application stored in session?
        # That's shady. Reset the session.
        reset_session
        redirect_to :home
        return
      end
    end

    if session.nil? or
       not session.has_key?(:application_group_id) or
       not session.has_key?(:online_application_id) or
       session[:application_group_id] == 0 or
       session[:online_application_id] == 0 or
       ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first.nil? or
       ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first.complete or
       OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first.nil? or
       action_name == 'new'
      begin
        # new application group
        @application_group = ApplicationGroup.new()
        # Trigger creation of session id, in case the session is new. We have to do this
        # because of lazy session loading.
        # Cf. https://rails.lighthouseapp.com/projects/8994/tickets/2268-rails-23-session_optionsid-problem
        # Ward, 2012-02-29
        request.session_options[:id]
        @application_group.session_id = request.session_options[:id]
        @application_group.browser = request.env['HTTP_USER_AGENT']
        @application_group.remote_ip = request.env['REMOTE_ADDR']
        @application_group.session_group_id = session[:session_group_id] if session.has_key?(:session_group_id)
        @application_group.save!

        # new application
        @online_application = OnlineApplication.new()
        @online_application.application_group = @application_group
        @online_application.application_group_order = @application_group.online_applications.count + 1
        @online_application.session_id = request.session_options[:id]
        if @application_group.online_applications.primary_applicant.size == 0
          @online_application.relation = 'primary applicant'
          @online_application.day_visit = false
        else
          @online_application.arrival = @application_group.online_applications.primary_applicant.first.arrival
          @online_application.departure = @application_group.online_applications.primary_applicant.first.departure
          @online_application.day_visit = @application_group.online_applications.primary_applicant.first.day_visit
        end

        # Save the application so we can refer back to it from the address model,
        # which is needed in the validation step there (i.e. to avoid address
        # validation at this time).
        @online_application.save!

        # Add a blank address (for permanent/correspondence address)
        @online_application.build_permanent_address

        @online_application.save!
      rescue Exception => e
        STDERR.puts "*******      ERROR      ********"
        STDERR.puts @application_group.pretty_inspect()
        STDERR.puts @online_application.pretty_inspect()
        STDERR.puts e.pretty_inspect()
        STDERR.puts "*******     /ERROR      ********"
        # Most likely, this means there is no session_id. That can happen if cookies are disabled.
        redirect_to :cookies_disabled
        return
      end
      session[:application_group_id] = @application_group.id
      session[:online_application_id] = @online_application.id
    else
      @application_group = ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first
      @online_application = OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first
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

end
