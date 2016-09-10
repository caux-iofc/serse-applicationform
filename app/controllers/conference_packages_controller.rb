class ConferencePackagesController < ApplicationController

  def index
    @start = params[:start]
    @stop = params[:stop]
    @start = Date.parse(@start).strftime("%Y-%m-%d") if @start
    @stop = Date.parse(@stop).strftime("%Y-%m-%d") if @stop

    @conference_packages = ConferencePackage.joins(:conference).where('rate_nightly = ? and date(conferences.start) = ? and date(conferences.stop) = ?',params[:rate_nightly],@start,@stop)

    if @conference_packages.empty?
      # No exact match. See if there are adjacent conferences that are a match.
      @cp1 = ConferencePackage.joins(:conference).where('rate_nightly = ? and date(conferences.start) = ?',params[:rate_nightly],@start)
      if not @cp1.empty?
        @cp1 = @cp1.first
        # Okay the start date matches a conference. See if there is another conference that starts the day the first one ends, and ends the day the person leaves
        @cp2 = ConferencePackage.joins(:conference).where('rate_nightly = ? and date(conferences.start) = ? and date(conferences.stop) = ?',params[:rate_nightly],@cp1.conference.stop.to_date,@stop)
        if not @cp2.empty?
          @cp2 = @cp2.first
          @conference_packages = ConferencePackage.joins(:conference).where('conference_packages.id in (?,?)',@cp1.id,@cp2.id)
        end
      end
    end

    # If eligible, apply the early bird discount to the package
    @conference_packages.each do |cp|
      cp.early_bird_pricing = false
      cp.early_bird_discount = 0
      if cp.conference and cp.conference.session_group and cp.conference.session_group.early_bird_register_by and Time.now() < cp.conference.session_group.early_bird_register_by
        if cp.rate.early_bird_discount_eligible
          if cp.conference.early_bird_discount_percentage > 0
            #cp.price = cp.price * (100 - cp.conference.early_bird_discount_percentage) / 100
            cp.early_bird_discount = cp.price * cp.conference.early_bird_discount_percentage / 100
            cp.early_bird_pricing = true
          end
        end
      end
    end

    # We naively use the first record in the form. Merge the relevant fields from both records
    # into the first one, if need be
    if @conference_packages.size > 1
      @conference_packages[0].price += @conference_packages[1].price
      @conference_packages[0].early_bird_discount += @conference_packages[1].early_bird_discount
      @conference_packages[0].early_bird_pricing = true if @conference_packages[1].early_bird_pricing
    end

    respond_to do |format|
      format.json { render :json => @conference_packages.map { |cp| cp.attributes.merge!(:early_bird_pricing => cp.early_bird_pricing, :early_bird_discount => cp.early_bird_discount) } }
    end
  end

end
