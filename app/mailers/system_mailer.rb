class SystemMailer < ActionMailer::Base
  default :from => SYSTEM_EMAIL
  default :to => SYSTEM_EMAIL

  def validation_failure_notification(message,the_request)
    @message = message

    @connection = ''
    @connection += "remote ip     = " + the_request.env['REMOTE_ADDR'] + "\n"
    @connection += "URI           = " + the_request.env['PATH_INFO'] + "\n"
    @connection += "host          = " + ROOT_URL + "\n"
    @connection += "date          = " + Time.now().to_s + "\n"

    @server = ''
    @server += "REQUEST_URI       = " + the_request.env['REQUEST_URI'] + "\n"
    @server += "QUERY_STRING      = " + the_request.env['QUERY_STRING'] + "\n"
    @server += "REMOTE_ADDR       = " + the_request.env['REMOTE_ADDR'] + "\n"
    @server += "HTTP_USER_AGENT   = " + the_request.env['HTTP_USER_AGENT'] + "\n"
    @server += "HTTP_REFERER      = " + the_request.env['HTTP_REFERER'] + "\n"
    @server += "REQUEST_METHOD    = " + the_request.env['REQUEST_METHOD'] + "\n"

    mail(:subject => "[#{ROOT_URL}] validation failure")
  end
  
end

