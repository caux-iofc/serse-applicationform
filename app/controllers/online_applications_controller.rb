class OnlineApplicationsController < ApplicationController

  before_filter :ensure_application_group

  # GET /online_applications
  # GET /online_applications.json
  def index
    @online_applications = OnlineApplication.find_all_by_application_group_id(@ag.id)

    if @online_applications.size == 0 then
      redirect_to :action => :new
      return
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @online_applications }
    end
  end

  # GET /online_applications/new
  # GET /online_applications/new.json
  def new
    @online_application = OnlineApplication.new
    # Add a blank address (for permanent/correspondence address)
    @online_application.build_permanent_address
    @online_application.build_correspondence_address

    if OnlineApplication.find_all_by_application_group_id(@ag.id).size == 0 then
      @online_application.relation = 'primary applicant'
    end

    populate_ethereal_variables

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @online_application }
    end
  end

  def populate_ethereal_variables

    # Make sure we have exactly two sponsor lines
    while @online_application.sponsors.size < 2 do
      @online_application.sponsors.build
    end

    # Make sure we have at least four online_application_language lines
    while @online_application.online_application_languages.size < 4 do
      @online_application.online_application_languages.build
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
      if not @conferences.has_key?(c.id) then
        @oac = @online_application.online_application_conferences.build({ :conference_id => c.id, :priority_sort => @priority_sort += 1 })
        @oac_normal << @oac
        # The user can choose 2 workstreams: a first choice and a second choice
        @oac.online_application_conference_workstreams.build({ :preference => 'first_choice' })
        @oac.online_application_conference_workstreams.build({ :preference => 'second_choice' })
      end
    end

    @priority_sort = 0
    Conference.special.where('session_group_id = ?',session[:session_group_id]).sort { |a,b| a.start <=> b.start }.each do |c|
      if not @conferences.has_key?(c.id) then
        @oac = @online_application.online_application_conferences.build({ :conference_id => c.id, :priority_sort => @priority_sort += 1 })
        @oac_special << @oac
      end
    end

    @languages = Language.with_translations.collect {|p| [ p.name, p.id ] }.sort
    @language_proficiencies = [ [t('proficiency_poor'),'110'], [t('proficiency_good'),'120'], [t('proficiency_excellent'),'130'], [t('proficiency_native'),'140'] ]

    @diets = @online_application.diets.collect { |d| d.id }

    @countries = [ [t(:other_please_specify),'0'] ] + Country.with_translations.sort { |a,b| a.name <=> b.name }.collect {|p| [ p.name, p.id ] }
  end

  # GET /online_applications/1/edit
  def edit
    @online_application = OnlineApplication.find(params[:id])
    # Populate the email_confirmation field
    @online_application.email_confirmation = @online_application.email

    # Add a blank address (for permanent/correspondence address) if either is nil
    # The permanent address should never be nil, but let's include it here just in case.
    # The correspondence address can be nil if it was not required on the
    # previous edit/creation of the online application.  It has to exist if we want it to
    # show up in the form if it becomes needed.
    @online_application.build_permanent_address if @online_application.permanent_address.nil?
    @online_application.build_correspondence_address if @online_application.correspondence_address.nil?

    populate_ethereal_variables

  end

  # POST /online_applications
  # POST /online_applications.json
  def create
    @online_application = OnlineApplication.new(params[:online_application])
    @online_application.application_group_id = @ag.id
    @online_application.application_group_order = @ag.online_applications.count + 1

    if @online_application.relation != 'primary applicant' and 
       (@ag.online_applications.empty? or @ag.online_applications.primary_applicant.first.nil?) then
      # Something funky is going on here. Most likely, they have already submitted this application.
      redirect_to :error
      return
    end

    if @online_application.relation != 'primary applicant' then
      @online_application.arrival = @ag.online_applications.primary_applicant.first.arrival
      @online_application.departure = @ag.online_applications.primary_applicant.first.departure
    end

    @online_application.the_request = request

    respond_to do |format|
      if @online_application.save
        format.html { redirect_to :action => 'index', :locale => params[:locale] }
        format.json { render :json => @online_application, :status => :created, :location => @online_application }
      else
        format.html {
          populate_ethereal_variables
          render :action => "new"
        }
        format.json { render :json => @online_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /online_applications/1
  # PUT /online_applications/1.json
  def update
    @online_application = OnlineApplication.find(params[:id])

    if not @ag.online_applications.include?(@online_application) then
      # Something funky is going on here. Most likely, they have already submitted this application.
      redirect_to :error
      return
    end

    @online_application.the_request = request

    # If no check boxes are checked, the form does not return those fields.
    # Handle that here, making sure that any diets, conferences, or
    # training programs previously selected will be removed.
    if not params[:online_application].has_key?('diet_ids') then
      params[:online_application]['diet_ids'] = []
    end
    if not params[:online_application].has_key?('training_program_ids') then
      params[:online_application]['training_program_ids'] = []
    end

    respond_to do |format|
      if @online_application.update_attributes(params[:online_application])
        format.html { redirect_to :action => 'index', :locale => params[:locale] }
        format.json { head :ok }
      else
        populate_ethereal_variables

        format.html { render :action => "edit" }
        format.json { render :json => @online_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /online_applications/1
  # DELETE /online_applications/1.json
  def destroy
    @online_application = OnlineApplication.find(params[:id])
    @online_application.destroy

    respond_to do |format|
      format.html { redirect_to online_applications_url }
      format.json { head :ok }
    end
  end

protected

  def ensure_application_group
    if session.nil? or not session.has_key?(:application_group_id) or session[:application_group_id] == 0 then
      begin
        # new application group
        @ag = ApplicationGroup.new()
        # Trigger creation of session id, in case the session is new. We have to do this
        # because of lazy session loading. 
        # Cf. https://rails.lighthouseapp.com/projects/8994/tickets/2268-rails-23-session_optionsid-problem
        # Ward, 2012-02-29
        request.session_options[:id]
        @ag.session_id = request.session_options[:id]
        @ag.browser = request.env['HTTP_USER_AGENT']
        @ag.remote_ip = request.env['REMOTE_ADDR']
        @ag.session_group_id = session[:session_group_id] if session.has_key?(:session_group_id)
        @ag.save!
      rescue Exception => e
        # Most likely, this means there is no session_id. That can happen if cookies are disabled.
        redirect_to :cookies_disabled
        return
      end
      session[:application_group_id] = @ag.id
    else
      @ag = ApplicationGroup.find(session[:application_group_id])
    end
  end

end
