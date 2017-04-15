class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :select_online_form
 
  def set_locale
    begin
      I18n.locale = params[:locale] || I18n.default_locale
    rescue I18n::InvalidLocale
      # This translates into the default 404 error in production
      raise ActionController::RoutingError.new('Not Found')
    end
  end  

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
      { :locale => I18n.locale }
  end


  def select_online_form
    # Allow forcing of session_group_id 
    if params.has_key?('override') then
      session[:override] = true
    end
    # Allow skipping the payment step
    if params.has_key?('skip_payment') and not SKIP_PAYMENT_SECRET.empty? and params[:skip_payment] == SKIP_PAYMENT_SECRET
      session[:skip_payment] = true
    end
    if params.has_key?('session_group_id') then
      session[:session_group_id] = params[:session_group_id]
    end
    if session[:override] and session[:session_group_id] then
      return
    end
    # But if it ain't forced, always set the session_group_id to the current 
    # session group
    of = OnlineForm.where('start < ? and stop > ?',Time.now(),Time.now()).order('id desc').first
    if of.nil? then
      redirect_to :form_unavailable
      false
    else
      session[:session_group_id] = of.session_group_id
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
      if @application_group.nil? or @online_application.nil? or
        @online_application.application_group.id != @application_group.id or
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

        # Add a blank address (for permanent address)
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
      # Make sure to clear the :skip_payment session value,
      # we do not want that to stick around in the session.
      session.delete :skip_payment
    else
      @application_group = ApplicationGroup.where(:id => session[:application_group_id], :session_id => request.session_options[:id]).first
      @online_application = OnlineApplication.where(:id => session[:online_application_id], :session_id => request.session_options[:id]).first
    end
  end

end
