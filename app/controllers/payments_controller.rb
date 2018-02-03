class PaymentsController < ApplicationController

  skip_before_filter :select_online_form

  # The out of band callback to the :post method doesn't carry any
  # session information
  before_filter :ensure_application_group, :except => :post

  # On the callback from the payment provider, we do not get a CSRF token
  # so we need to disable that check, lest the session gets reset!
  # On the out of band :post callback, there is no session.
  skip_before_filter :verify_authenticity_token, :only => [:callback, :post]

  def redirect_to_processor
    if @application_group.payment_required != @application_group.payment_received then
       # redirect to payment processor
       amount = ((@application_group.payment_required - @application_group.payment_received) * 100).to_s
       refno = @application_group.id
       signature = view_context.sign(PAYMENT_PROCESSOR_MERCHANT_ID,amount,PAYMENT_PROCESSOR_CURRENCY,refno)
       # redirect to payment processor
       redirect_to view_context.generate_url(PAYMENT_PROCESSOR_URL,
         :merchantId => PAYMENT_PROCESSOR_MERCHANT_ID,
         :refno => refno,
         :amount => amount,
         :currency => PAYMENT_PROCESSOR_CURRENCY,
         :sign => signature)
       return
    else
      redirect_to build_path(:confirmation)
    end
  end

  def callback
    # Verify merchantId and currency
    if params[:merchantId] != PAYMENT_PROCESSOR_MERCHANT_ID or params[:currency] != PAYMENT_PROCESSOR_CURRENCY
      # Invalid request
      STDERR.puts "******* Payment callback invalid: invalid merchantId or currency ********"
      require 'pp'
      STDERR.puts ""
      STDERR.puts "Request information:"
      STDERR.puts request.pretty_inspect()
      STDERR.puts "******* /Breakin attempt ********"
      reset_session
      redirect_to :home
      return
    end

    if params[:status] == 'success'
      # Verify general signature on callback
      calculated_signature = view_context.sign(PAYMENT_PROCESSOR_MERCHANT_ID,params[:amount],PAYMENT_PROCESSOR_CURRENCY,params[:refno])
      if params[:sign] != calculated_signature
        # Invalid request
        STDERR.puts "******* Payment callback invalid: invalid signature ********"
        require 'pp'
        STDERR.puts ""
        STDERR.puts "Request information:"
        STDERR.puts request.pretty_inspect()
        STDERR.puts "******* /invalid signature ********"
        reset_session
        redirect_to :home
        return
      end

      # Verify second signature on callback
      calculated_signature = view_context.sign(PAYMENT_PROCESSOR_MERCHANT_ID,params[:amount],PAYMENT_PROCESSOR_CURRENCY,params[:uppTransactionId])
      if params[:sign2] != calculated_signature
        # Invalid request
        STDERR.puts "******* Payment callback invalid: invalid signature (sign2) ********"
        require 'pp'
        STDERR.puts ""
        STDERR.puts "Request information:"
        STDERR.puts request.pretty_inspect()
        STDERR.puts "******* /invalid signature (sign2) ********"
        reset_session
        redirect_to :home
        return
      end

      @application_group.payment_received = (params[:amount].to_i / 100).to_i
      @application_group.payment_reference = params.except('expm','expy','cardno','controller','action').to_json
      @application_group.payment_currency = PAYMENT_PROCESSOR_CURRENCY
      @application_group.save!

      @application_group.complete!
      redirect_to build_path(Wicked::FINISH_STEP)
    elsif params[:status] == 'error'
      STDERR.puts "******* Payment callback: error status ********"
      require 'pp'
      STDERR.puts ""
      STDERR.puts "Request information:"
      STDERR.puts request.pretty_inspect()
      STDERR.puts "******* /error status ********"
      flash[:error] = "Error processing your payment. Please try again."
      redirect_to build_path(:payment)
      return
    elsif params[:status] == 'cancel'
      STDERR.puts "******* Payment callback: cancel status ********"
      require 'pp'
      STDERR.puts ""
      STDERR.puts "Request information:"
      STDERR.puts request.pretty_inspect()
      STDERR.puts "******* /cancel status ********"
      # Cancel happens when they hit the back arrow on the payment page; no need to
      # put a special warning about that on the payment page.
      redirect_to build_path(:payment)
      return
    end
  end

  def post
    log_post
  end

  def log_post
    require 'pp'
    params.each do |k,v|
      STDERR.puts k
      STDERR.puts v
    end
  end

end
