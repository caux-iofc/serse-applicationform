class OnlineApplications::BuildController < ApplicationController

  before_filter :ensure_application_group

  include Wicked::Wizard
  steps :personal, :group, :family, :detail, :dates_and_events, :visa, :finances, :confirmation

  def show
    @step = step

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

    if step == :group or step == :family or step == :detail or step == :visa or step == :confirmation
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
    if step != :group and step != :family and step != :detail and step != :visa and step != :confirmation and step != :finances
      @online_application.the_request = request

      # If no check boxes are checked, the form does not return those fields.
      # Handle that here, making sure that any training programs previously
      # selected will be removed.
      if not params[:online_application].has_key?('training_program_ids') then
        params[:online_application]['training_program_ids'] = []
      end

      # Make sure we delete online_application_conferences records that are not selected
      if params[:online_application].has_key?('online_application_conferences_attributes')
        params[:online_application]['online_application_conferences_attributes'].each do |k,v|
          v['_destroy'] = true if v['selected'] != '1'
        end
      end

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
        if step == :dates_and_events
          params[:online_application].delete('relation')
          # Save the dates and events information for every participant in the group
          @application_group.online_applications.other_applicants.each do |oa|
            # Sub-objects get their own IDs for each participant, so we need to rewrite them for update/delete
            @online_application_conferences_attributes = params[:online_application]['online_application_conferences_attributes']
            @online_application_conferences_attributes.each do |index,oac|
              if oac.has_key?('id') and oa.online_application_conferences.collect { |o| o.conference_id }.include?(oac['conference_id'].to_i)
                oac['id'] = oa.online_application_conferences.where(:conference_id => oac['conference_id']).first.id
              end
              @online_application_conference_workstreams_attributes = oac["online_application_conference_workstreams_attributes"]
              next if @online_application_conference_workstreams_attributes.nil?
              next if not oac.has_key?('id') or oac['id'].nil? or oac['id'].to_s.empty?
              # Unfortunately, we also need to rewrite IDs on sub-sub-objects...
              @online_application_conference_workstreams_attributes.each do |i,oacw|
                db_oac = OnlineApplicationConference.find(oac['id'].to_i)
                if oacw.has_key?('id') and db_oac.online_application_conference_workstreams.collect { |o| o.preference }.include?(oacw['preference'])
                  oacw['id'] = db_oac.online_application_conference_workstreams.where(:preference => oacw['preference']).first.id
                end
              end
            end
            params[:online_application]['online_application_conferences_attributes'] = @online_application_conferences_attributes
            oa.update_attributes!(params[:online_application])
          end
        end
      end
    else
      if step == :group and params[:application_group].has_key?('online_applications_attributes')
        # Do not save permanent address information if the 'different address' checkbox is not set
        params[:application_group]['online_applications_attributes'].each do |key,val|
          val['permanent_address_attributes']['_destroy'] = true if val['different_address'] != '1'
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
    if @online_applications.size == 0 or @application_group.complete
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

    @earliest_start_year = Time.now.year
    @latest_stop_year = Time.now.year

    # Make sure we have exactly two sponsor lines
    while @online_application.sponsors.size < 2 do
      @online_application.sponsors.build
    end

    # Make sure we have at least four online_application_language lines for each
    # applicant in the group
    @application_group.online_applications.each do |oa|
      while oa.online_application_languages.size < 4 do
        oa.online_application_languages.build
      end
    end

    @oac_normal = Array.new()
    @oac_special = Array.new()

    # For some reason @online_application.online_application_conferences.find_by_conference_id(c.id).nil?
    # does not work on records that were created with 'build' (presumably because they are not saved yet).
    # So, use this workaround.
    @conferences = Hash.new()
    @online_application.online_application_conferences.each do |oac|
      if oac.conference.special == false then
        @oac_normal << oac
      else
        @oac_special << oac
      end
      @conferences[oac.conference_id] = true
    end

    @priority_sort = 0
    Conference.normal.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
      @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
      @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
      if not @conferences.has_key?(c.id) then
        @oac = OnlineApplicationConference.new({ :online_application_id => @online_application.id, :conference_id => c.id, :priority_sort => @priority_sort += 1 })
        @oac_normal << @oac
        # The user can choose 2 workstreams: a first choice and a second choice
        @oac.online_application_conference_workstreams.build({ :preference => 'first_choice' })
        @oac.online_application_conference_workstreams.build({ :preference => 'second_choice' })
      end
    end

    @priority_sort = 0
    Conference.special.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
      @earliest_start_year = c.start.year if c.start.year < @earliest_start_year
      @latest_stop_year = c.stop.year if c.stop.year > @latest_stop_year
      if not @conferences.has_key?(c.id) then
        @oac = OnlineApplicationConference.new({ :online_application_id => @online_application.id, :conference_id => c.id, :priority_sort => @priority_sort += 1 })
        @oac_special << @oac
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
      if step == :group or step == :family
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
          oa.rate = 'family' if @application_group.family_registration and oa.relation != 'primary applicant'
        end
        # these fields are used to pass information to the javascript that calculates the rates
        oa.caux_scholar = (oa.training_programs.collect { |tp| tp.name }.include?('Caux Scholars Program') ? 1 : 0)
        oa.caux_intern = ((oa.training_programs.collect { |tp| tp.name }.grep /^Caux Interns Program/).empty? ? 0 : 1)
        oa.caux_artist = (oa.training_programs.collect { |tp| tp.name }.include?('Caux Artists Program') ? 1 : 0)
        oa.week_of_international_community = (oa.training_programs.collect { |tp| tp.name }.include?('Week of International Community') ? 1 : 0)
        oa.conference_team = (oa.online_application_conferences.collect { |oac| oac.role_team }.include?(true) ? 1 : 0)
        oa.conference_speaker = (oa.online_application_conferences.collect { |oac| oac.role_speaker }.include?(true) ? 1 : 0)
      end
    end
  end

  def ensure_application_group
    if session.nil? or
       not session.has_key?(:application_group_id) or
       session[:application_group_id] == 0 or
       ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first.nil? or
       ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first.complete then
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
      rescue Exception => e
        # Most likely, this means there is no session_id. That can happen if cookies are disabled.
        redirect_to :cookies_disabled
        return
      end
      session[:application_group_id] = @application_group.id
      session.delete(:online_application_id)
    else
      @application_group = ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first
    end

    # Allow selection of a application, if the session id matches
    if not session.nil? and params[:online_application_id]
      @online_application = OnlineApplication.where(:id => params[:online_application_id], :session_id => request.session_options[:id]).first
      if not @online_application.nil?
        session[:online_application_id] = @online_application.id
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
      end
    end

    if session.nil? or
       not session.has_key?(:online_application_id) or
       session[:online_application_id] == 0 or
       OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first.nil? or
       action_name == 'new' then
      begin
        # new application
        # Trigger creation of session id, in case the session is new. We have to do this
        # because of lazy session loading.
        # Cf. https://rails.lighthouseapp.com/projects/8994/tickets/2268-rails-23-session_optionsid-problem
        # Ward, 2012-02-29
        request.session_options[:id]
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
        # Most likely, this means there is no session_id. That can happen if cookies are disabled.
        redirect_to :cookies_disabled
        return
      end
      session[:online_application_id] = @online_application.id
    else
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
