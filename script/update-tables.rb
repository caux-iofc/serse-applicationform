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
  of.early_bird_register_by = v['early_bird_register_by']
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
y = YAML.load_file( "#{Rails.root}/tmp_script/conferences.yml" )
y.sort.each do |k,v|
  of = Conference.find_by_serse_id(v['id'])
  if of.nil? then
    of = Conference.new
  end
  of.serse_id = v['id']
  of.session_group_id = v['session_group_id']
  of.early_bird_discount_percentage = v['early_bird_discount_percentage']
  of.start = v['start']
  of.stop = v['stop']
  of.private = v['private']
  of.special = v['special']
  of.full = v['full']
  of.display_dates = v['display_dates']
  of.abbreviation = v['abbreviation']
  dd = DateTime.parse(v['start'].to_s)
  of.template_path = dd.strftime("%Y") + '/' + v['abbreviation'].downcase

  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.save
  @objects[of.id] = true
end

y = YAML.load_file( "#{Rails.root}/tmp_script/conference_translations.yml" )
y.sort.each do |k,v|
  of = Conference.find_by_serse_id(v['conference_id'])
  if of.nil? then
    of = Conference.new
  end
  I18n.locale = v['locale']
  of.name = v['name']
  of.byline = v['byline']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.save
  I18n.locale = 'en'
  @objects[of.id] = true
end

Conference.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/rates.yml" )
y.sort.each do |k,v|
  of = Rate.find_by_serse_id(v['id'])
  if of.nil? then
    of = Rate.new
  end
  of.serse_id = v['id']
  of.name = v['name']

  of.from_age = v['from_age']
  of.to_age = v['to_age']
  of.early_bird_discount_eligible = v['early_bird_discount_eligible']
  of.student = v['student']
  of.maintenance = v['maintenance']
  of.daily_chf = v['daily_chf']
  of.daily_eur = v['daily_eur']
  of.daily_usd = v['daily_usd']

  of.created_by = v['created_by']
  of.updated_by = v['updated_by']
  of.updated_by = v['deleted_by']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.deleted_at = v['deleted_at']
  of.save
  @objects[of.id] = true
end

Rate.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/conference_packages.yml" )
y.sort.each do |k,v|
  of = ConferencePackage.find_by_serse_id(v['id'])
  if of.nil? then
    of = ConferencePackage.new
  end
  of.serse_id = v['id']
  of.conference_id = Conference.find_by_serse_id(v['conference_id']).id
  of.price = v['price']
  of.rate_id = Rate.find_by_serse_id(v['rate_id']).id
  of.rate_nightly = v['rate_nightly']
  of.currency = v['currency']

  of.created_by = v['created_by']
  of.updated_by = v['updated_by']
  of.updated_by = v['deleted_by']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.deleted_at = v['deleted_at']
  of.save
  @objects[of.id] = true
end

ConferencePackage.all.each do |o|
  if not @objects.has_key?(o.id) then
    o.destroy!
  end
end

@objects = Hash.new()
y = YAML.load_file( "#{Rails.root}/tmp_script/conference_workstreams.yml" )
y.sort.each do |k,v|
  of = ConferenceWorkstream.find_by_serse_id(v['id'])
  if of.nil? then
    of = ConferenceWorkstream.new
  end
  of.serse_id = v['id']
  of.conference_id = Conference.find_by_serse_id(v['conference_id']).id
  of.priority_sort = v['priority_sort']
  of.created_by = v['created_by']
  of.updated_by = v['updated_by']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.deleted_at = v['deleted_at']
  of.save
  @objects[of.id] = true
end

y = YAML.load_file( "#{Rails.root}/tmp_script/conference_workstream_translations.yml" )
y.sort.each do |k,v|
  of = ConferenceWorkstream.find_by_serse_id(v['conference_workstream_id'])
  if of.nil? then
    of = ConferenceWorkstream.new
  end
  I18n.locale = v['locale']
  of.name = v['name']
  of.byline = v['byline']
  of.language = v['language']
  of.created_at = v['created_at']
  of.updated_at = v['updated_at']
  of.save
  I18n.locale = 'en'
  @objects[of.id] = true
end

ConferenceWorkstream.all.each do |o|
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


