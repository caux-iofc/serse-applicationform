 
 # We load cure_acts_as_versioned in the Gemfile, but that gem really defines 'acts_as_versioned'
 require 'acts_as_versioned'
 # We load cure_rails3_acts_as_paranoid in the Gemfile, but that gem really defines 'rails3_acts_as_paranoid'
 #require 'rails3_acts_as_paranoid'
 require 'acts_as_paranoid'

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

# Configure the default encoding used in templates for Ruby 1.9.
#SerseApplication::Application.config.encoding = "utf-8"

# Configure sensitive parameters which will be filtered from the log file.
#SerseApplication::Application.config.filter_parameters += [:password]

# Enable escaping HTML in JSON.
#config.active_support.escape_html_entities_in_json = true

# Use SQL instead of Active Record's schema dumper when creating the database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

### Enforce whitelist mode for mass assignment.
### This will create an empty whitelist of attributes available for mass-assignment for all models
### in your app. As such, your models will need to explicitly whitelist or blacklist accessible
### parameters by using an attr_accessible or attr_protected declaration.
##config.active_record.whitelist_attributes = true

# Enable the asset pipeline
#config.assets.enabled = true

# Version of your assets, change this if you want to expire all your assets
#config.assets.version = '1.0'

# Do not wrap form labels with the 'field_with_errors' wrapper,
# and use a *span* instead of a div for the form input fields.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  include ActionView::Helpers::OutputSafetyHelper
  if /<label for=/.match(html_tag) then
    html_tag.html_safe
  else
    raw %(<span class="field_with_errors">#{html_tag}</span>)
  end
end
