 
 # We load cure_acts_as_versioned in the Gemfile, but that gem really defines 'acts_as_versioned'
 require 'acts_as_versioned'

Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e %Y") }
