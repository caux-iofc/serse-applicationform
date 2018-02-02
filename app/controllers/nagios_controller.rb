class NagiosController < ApplicationController

  skip_before_filter :set_locale
  skip_before_filter :select_online_form

  # Public url that provides data for a nagios check
  def application_groups
    oldest_waiting = ApplicationGroup.complete.where(:copied_to_serse => 0).order(:updated_at).first
    waiting = ApplicationGroup.complete.where(:copied_to_serse => 0).size.to_s
    if not oldest_waiting.nil? and oldest_waiting.updated_at < Time.now - 15.minutes
      render :plain => "CRITICAL: " + waiting + " application groups waiting for download (oldest older than 15 minutes)"
    else
      render :plain => "OK: " + waiting + " application groups waiting for download"
    end
  end

end
