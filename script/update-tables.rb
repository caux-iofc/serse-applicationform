#!/usr/bin/env ruby

require 'date'

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/tbl_online_forms.yml" )
y.sort.each do |k,v| 
  of = OnlineForm.find_by_serse_id(v['id'])
  if of.nil? then
    of = OnlineForm.new
  end
  of.serse_id = v['id']
  of.start = v['start']
  of.stop = v['stop']
  of.session_group_id = v['session_group_id']
  of.created_at = DateTime.strptime(v['epoch'],'%s')
  of.updated_at = DateTime.strptime(v['epoch'],'%s')
  of.save
  @objects[of.id] = true
end

OnlineForm.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/session_groups.yml" )
y.sort.each do |k,v| 
  of = SessionGroup.find_by_serse_id(v['id'])
  if of.nil? then
    of = SessionGroup.new
  end
  of.serse_id = v['id']
  of.name = v['name']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.save
  @objects[of.id] = true
end

SessionGroup.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/tbl_countries.yml" )
y.sort.each do |k,v| 
  of = Country.find_by_serse_id(v['id'])
  if of.nil? then
    of = Country.new
  end
  of.serse_id = v['id']
  of.state_order = v['stateorder']
  of.zipcode_order = v['zipcodeorder']
  I18n.locale = 'fr'
  of.name = v['name_1']
  I18n.locale = 'de'
  of.name = v['name_2']
  I18n.locale = 'en'
  of.name = v['name_3']
  of.created_at = DateTime.strptime(v['epoch'],'%s')
  of.updated_at = DateTime.strptime(v['epoch'],'%s')
  of.save
  @objects[of.id] = true
end

Country.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/tbl_languages.yml" )
y.sort.each do |k,v| 
  of = Language.find_by_serse_id(v['id'])
  if of.nil? then
    of = Language.new
  end
  of.serse_id = v['id']
  of.priority_sort = v['priority_sort']
  I18n.locale = 'fr'
  of.name = v['name']
  I18n.locale = 'de'
  of.name = v['name']
  I18n.locale = 'en'
  of.name = v['name']
  of.created_at = DateTime.strptime(v['epoch'],'%s')
  of.updated_at = DateTime.strptime(v['epoch'],'%s')
  of.save
  @objects[of.id] = true
end

OnlineForm.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/tbl_sessions.yml" )
y.sort.each do |k,v| 
  of = Conference.find_by_serse_id(v['id'])
  if of.nil? then
    of = Conference.new
  end
  of.serse_id = v['id']
  of.session_group_id = v['session_group_id']
  of.start = v['start']
  of.stop = v['stop']
  of.private = v['private']
  of.special = v['special']
  of.display_dates = v['display_dates']
  of.abbreviation = v['abbrev']
  dd = DateTime.parse(v['start'])
  of.template_path = dd.strftime("%Y") + '/' + v['abbrev'].downcase

  of.created_at = DateTime.strptime(v['epoch'],'%s')
  of.updated_at = DateTime.strptime(v['epoch'],'%s')
  of.save
  @objects[of.id] = true
end

y = YAML.load_file( "#{Rails.root}/tmp_script/tbl_session_names.yml" )
y.sort.each do |k,v| 
  of = Conference.find_by_serse_id(v['session_id'])
  if of.nil? then
    of = Conference.new
  end
  of.serse_id = v['session_id']
  if v['language_id'] == '74' then
    I18n.locale = 'fr'
    of.name = v['name']
  elsif v['language_id'] == '89' then
    I18n.locale = 'de'
    of.name = v['name']
  elsif v['language_id'] == '63' then
    I18n.locale = 'en'
    of.name = v['name']
  end
  of.save
  @objects[of.id] = true
end

Conference.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/training_programs.yml" )
y.sort.each do |k,v| 
  of = TrainingProgram.find_by_serse_id(v['id'])
  if of.nil? then
    of = TrainingProgram.new
  end
  of.serse_id = v['id']
  of.display_dates = v['display_dates']
  of.session_group_id = v['session_group_id']
  of.start = v['start']
  of.stop = v['stop']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.save
  @objects[of.id] = true
end

y = YAML.load_file( "#{Rails.root}/tmp_script/training_program_names.yml" )
y.sort.each do |k,v| 
  of = TrainingProgram.find_by_serse_id(v['training_program_id'])
  if of.nil? then
    of = TrainingProgram.new
  end
  of.serse_id = v['training_program_id']
  if v['language_id'] == '74' then
    I18n.locale = 'fr'
    of.name = v['name']
  elsif v['language_id'] == '89' then
    I18n.locale = 'de'
    of.name = v['name']
  elsif v['language_id'] == '63' then
    I18n.locale = 'en'
    of.name = v['name']
  end
  of.save
  @objects[of.id] = true
end

TrainingProgram.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end


