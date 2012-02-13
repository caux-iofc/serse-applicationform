class OnlineApplicationsController < ApplicationController
  # GET /online_applications
  # GET /online_applications.json
  def index

    if session.has_key?(:application_group_id) and session[:application_group_id] != 0 then
      @online_applications = OnlineApplication.find_all_by_application_group_id(session[:application_group_id])
    else
      @online_applications = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @online_applications }
    end
  end

  # GET /online_applications/1
  # GET /online_applications/1.json
  def show
    @online_application = OnlineApplication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @online_application }
    end
  end

  # GET /online_applications/new
  # GET /online_applications/new.json
  def new
    @online_application = OnlineApplication.new
    # Add a blank address (for permanent/correspondence address)
    @online_application.permanent_address = PermanentAddress.new()
    @online_application.correspondence_address = CorrespondenceAddress.new()
    # And two sponsor lines
    @online_application.sponsors.build
    @online_application.sponsors.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @online_application }
    end
  end

  # GET /online_applications/1/edit
  def edit
    @online_application = OnlineApplication.find(params[:id])
    @online_application.email_confirmation = @online_application.email
  end

  # POST /online_applications
  # POST /online_applications.json
  def create
    # TODO: FIXME: what if session is null? Force creation of a session? Shouldn't rails do this for us?
    if not session.has_key?(:application_group_id) and session[:application_group_id] != 0 then
      # new application group
      ag = ApplicationGroup.new()
      ag.session_id = request.session_options[:id]
      ag.browser = request.env['HTTP_USER_AGENT']
      ag.save!
      session[:application_group_id] = ag.id
    else
      ag = ApplicationGroup.find(session[:application_group_id])
    end

    @online_application = OnlineApplication.new(params[:online_application])
    @online_application.application_group_id = ag.id
    @online_application.application_group_order = ag.online_applications.count + 1
    if ag.online_applications.count == 0 then
      @online_application.relation = 'primary applicant'
    end

    # We only care about the correspondence address if we need it
    if @online_application.confirmation_letter_via != "correspondence_address" then
      @online_application.correspondence_address.destroy!
    end

    # And two sponsor lines
    @online_application.sponsors.build
    @online_application.sponsors.build

    respond_to do |format|
      if @online_application.save
        format.html { redirect_to online_applications_url, :notice => 'Online application was successfully created.' }
        format.json { render :json => @online_application, :status => :created, :location => @online_application }
      else
        format.html { render :action => "new" }
        format.json { render :json => @online_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /online_applications/1
  # PUT /online_applications/1.json
  def update
    @online_application = OnlineApplication.find(params[:id])

    # We only care about the correspondence address if we need it
    if @online_application.confirmation_letter_via != "correspondence_address" then
      @online_application.correspondence_address.destroy!
    end

    respond_to do |format|
      if @online_application.update_attributes(params[:online_application])
        format.html { redirect_to online_applications_url, :notice => 'Online application was successfully updated.' }
        format.json { head :ok }
      else
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
end
