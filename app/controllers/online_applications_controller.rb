class OnlineApplicationsController < ApplicationController
  # GET /online_applications
  # GET /online_applications.json
  def index
    @online_applications = OnlineApplication.all

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
    # Add a blank address (for permanent address)
    @online_application.addresses.build
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
  end

  # POST /online_applications
  # POST /online_applications.json
  def create
    @online_application = OnlineApplication.new(params[:online_application])
    # And two sponsor lines
    @online_application.sponsors.build
    @online_application.sponsors.build

    respond_to do |format|
      if @online_application.save
        format.html { redirect_to @online_application, :notice => 'Online application was successfully created.' }
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

    respond_to do |format|
      if @online_application.update_attributes(params[:online_application])
        format.html { redirect_to @online_application, :notice => 'Online application was successfully updated.' }
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
