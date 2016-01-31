class ConferencePackagesController < ApplicationController

  def index
    @start = params[:start]
    @stop = params[:stop]
    @start = Date.parse(@start).strftime("%Y-%m-%d") if @start
    @stop = Date.parse(@stop).strftime("%Y-%m-%d") if @stop

    @conference_packages = ConferencePackage.joins(:conference).where('rate_nightly = ? and date(conferences.start) = ? and date(conferences.stop) = ?',params[:rate_nightly],@start,@stop)

    # If eligible, apply the early bird discount to the package
    @conference_packages.each do |cp|
      cp.early_bird_pricing = false
      cp.early_bird_discount = 0
      if cp.conference.session_group.early_bird_register_by and Time.now() < cp.conference.session_group.early_bird_register_by
        if cp.rate.early_bird_discount_eligible
          if cp.conference.early_bird_discount_percentage > 0
            #cp.price = cp.price * (100 - cp.conference.early_bird_discount_percentage) / 100
            cp.early_bird_discount = cp.price * cp.conference.early_bird_discount_percentage / 100
            cp.early_bird_pricing = true
          end
        end
      end
    end

    respond_to do |format|
      format.json { render :json => @conference_packages.map { |cp| cp.attributes.merge!(:early_bird_pricing => cp.early_bird_pricing, :early_bird_discount => cp.early_bird_discount) } }
    end
  end

end
