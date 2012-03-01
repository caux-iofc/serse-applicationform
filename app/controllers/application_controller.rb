class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :select_online_form
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
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
    if params.has_key?('session_group_id') then
      session[:session_group_id] = params[:session_group_id]
    end
    if session[:override] and session[:session_group_id] then
      return
    end
    # But if it ain't forced, always set the session_group_id to the current 
    # session group
    of = OnlineForm.where('start < ? and stop > ?',Time.now(),Time.now()).first
    if of.nil? then
      redirect_to :form_unavailable
      false
    else
      session[:session_group_id] = of.session_group_id
    end
  end
end
