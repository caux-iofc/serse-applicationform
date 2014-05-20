class ApplicationGroupsController < ApplicationController

  def submit
    if session.has_key?(:application_group_id) and session[:application_group_id] != 0 then
      @application_group = ApplicationGroup.find(session[:application_group_id])
      if @application_group.complete then
        # This application group has already been submitted
        redirect_to :action => :submitted
        return
      end
      if @application_group.online_applications.count == 0 then
        # This is an empty application group; probably emptied in another window
        @application_group = nil
        redirect_to :new_online_application
        return
      end
      @application_group.data_protection_caux_info = true
      @application_group.data_protection_local_info = true
    else
      @application_group = nil
      redirect_to :new_online_application
    end
  end

  def update
    # Make sure that
    # a) there's a valid session with an application_group_id
    # b) that application_group_id is not zero
    # c) the id parameter passed in the PUT matches the session application_group_id
    # Option c) protects against re-submission of the final form.
    if session.has_key?(:application_group_id) and
       session[:application_group_id] != 0 and
       session[:application_group_id].to_s == params[:id].to_s then
      @application_group = ApplicationGroup.find(session[:application_group_id])
    else
      @application_group = nil
      redirect_to :new_online_application
      return
    end

    @application_group.attributes = params[:application_group]
    # Just to be sure
    @application_group.session_group_id = session[:session_group_id]

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

end
