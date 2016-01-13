class ConferencePackagesController < ApplicationController

  def index
    @start = params[:start]
    @stop = params[:stop]
    @start = Date.parse(@start).strftime("%Y-%m-%d") if @start
    @stop = Date.parse(@stop).strftime("%Y-%m-%d") if @stop

    @conference_packages = ConferencePackage.joins(:conference).where('rate_nightly = ? and date(conferences.start) = ? and date(conferences.stop) = ?',params[:rate_nightly],@start,@stop)

    respond_to do |format|
      format.json { render :json => @conference_packages }
    end
  end

end
