#!/usr/bin/env ruby

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def new_ws(conference_id,priority_sort,name,byline='',language='')
  cw = ConferenceWorkstream.find_by_name(name)
  if cw.nil? then
    cw = ConferenceWorkstream.new()
  end
  cw.conference_id = conference_id
  cw.name = name
  cw.byline = byline
  cw.language = language
  cw.priority_sort = priority_sort
  cw.save!
end

@conference_id = Conference.with_translations.where("session_group_id = 12 and name = 'Learning to live in a Multicultural World'").first.id
@sort = 0

new_ws(@conference_id,@sort += 1,'Youth as empowered civil society actors','An interactive workshop by youth for youth who want to actively shape our future societies','English')
new_ws(@conference_id,@sort += 1,'Empowering Women\'s Leadership within Civil Society','','Spanish, with interpretation')
new_ws(@conference_id,@sort += 1,'Building Trust between Generations, Communities and Cultures','','English')
new_ws(@conference_id,@sort += 1,'Pedagogy for the Child as Global Citizen','Children & Youth as Teachers','English')
new_ws(@conference_id,@sort += 1,'Social Practice in the Making','An interactive, experiential learning experience with Critical Mass Foundation','English')
new_ws(@conference_id,@sort += 1,'Media and its responsibilities','Creating a perception of the "Other"','English')
new_ws(@conference_id,@sort += 1,'Anti-discrimination and religious diversity','','English')

@conference_id = Conference.with_translations.where("session_group_id = 12 and name = 'Trust and integrity in the global economy'").first.id
@sort = 0

new_ws(@conference_id,@sort += 1,'Reshaping Business','Reshaping Business around Core Values','English')
new_ws(@conference_id,@sort += 1,'Food and Development','Food and the New Development Paradigm: Farmers, consumers and business protecting our common environmental future.','English')
new_ws(@conference_id,@sort += 1,'Sustainable World','Leading Change for a Sustainable World.','English')
new_ws(@conference_id,@sort += 1,'Leadership','Authentic Self-Leadership','English')
new_ws(@conference_id,@sort += 1,'Integral Economy','Integral Economy and Integral Society','English')
new_ws(@conference_id,@sort += 1,'Learning Society','Creating a Learning Society','English')


I18n.locale = 'en'

tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Caux Scholars Program','12').first
tp.byline = 'Please note that is not the application form for the Caux Scholars Program. This is to register for those who have already applied and have been accepted.'
tp.save


tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Caux Interns Program - Session 1','12').first
tp.byline = 'Please note that is not the application form for the Caux Interns Program. This is to register for those who have already applied and have been accepted.'
tp.save

tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Caux Interns Program - Session 2','12').first
tp.byline = 'Please note that is not the application form for the Caux Interns Program. This is to register for those who have already applied and have been accepted.'
tp.save


