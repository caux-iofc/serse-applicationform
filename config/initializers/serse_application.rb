 
 # We load cure_acts_as_versioned in the Gemfile, but that gem really defines 'acts_as_versioned'
 require 'acts_as_versioned'
 # We load cure_rails3_acts_as_paranoid in the Gemfile, but that gem really defines 'rails3_acts_as_paranoid'
 require 'rails3_acts_as_paranoid'

Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e %Y") }
