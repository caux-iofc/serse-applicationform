class ApplicationGroupsController < ApplicationController

  def submit
    if session.has_key?(:application_group_id) and session[:application_group_id] != 0 then
      @application_group = ApplicationGroup.find(session[:application_group_id])
      if @application_group.complete then
        # This application group has already been submitted
        redirect_to :action => :submitted
        return
      end
      @application_group.data_protection_caux_info = true
      @application_group.data_protection_local_info = true
      @application_group.session_group_id = session[:session_group_id]
      @application_group.save
    else
      @application_group = nil
      redirect_to :new_online_application
    end
  end

  def update
    if session.has_key?(:application_group_id) and session[:application_group_id] != 0 then
      @application_group = ApplicationGroup.find(session[:application_group_id])
    else
      @application_group = nil
      redirect_to :new_online_application
      return
    end

    @application_group.attributes = params[:application_group]

    respond_to do |format|
      if @application_group.valid? then
        @application_group.complete = true
        @application_group.save
        # No more changes to this application group
        session[:application_group_id] = 0
        format.html { redirect_to application_group_submitted_url, :notice => 'Thank you, your application was submitted.' }
        format.json { head :ok }
      else
        format.html { render :action => "submit" }
        format.json { render :json => @application_group.errors, :status => :unprocessable_entity }
      end
    end
  end

#  def show
#    redirect_to :controller => :online_applications, :action => :index
#  end

end
