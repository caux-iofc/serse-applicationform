 
 # We load cure_acts_as_versioned in the Gemfile, but that gem really defines 'acts_as_versioned'
 require 'acts_as_versioned'
 # We load cure_rails3_acts_as_paranoid in the Gemfile, but that gem really defines 'rails3_acts_as_paranoid'
 require 'rails3_acts_as_paranoid'

# Enable e-mail exception notification middleware in production mode
if Rails.env == 'production'
  SerseApplication::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[Serse Application Form] ",
      :sender_address => %{"Application Error" <#{SYSTEM_EMAIL}>},
      :exception_recipients => SYSTEM_EMAIL,
    }
end

Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e %Y") }
