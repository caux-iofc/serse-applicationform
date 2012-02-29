class HomeController < ApplicationController

  skip_before_filter :select_online_form, :only => [:form_unavailable]

  def index
    redirect_to "/#{I18n.locale}/online_applications"
  end

  def form_unavailable
    of = OnlineForm.where('start < ? and stop > ?',Time.now(),Time.now()).first
    if not of.nil? then
      # There is a valid form, but someone is hitting this URL directly. Redirect them.
      redirect_to :home
      return
    end
  end

end
