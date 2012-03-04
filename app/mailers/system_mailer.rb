class SystemMailer < ActionMailer::Base
  default :from => SYSTEM_EMAIL
  default :to => SYSTEM_EMAIL

  def validation_failure_notification(message)
    mail(:subject => "[#{ROOT_URL}] validation failure", :message => message)
  end
  
end

