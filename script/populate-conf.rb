#!/usr/bin/env ruby

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def update_ws(name,locale,local_name,local_byline=nil,local_language='')
  local_name = nil if local_name == ''
  local_byline = nil if local_byline == ''
  local_language = '' if local_language == 'English'
  cw = ConferenceWorkstream.find_by_name(name)
  if cw.nil? then
    STDERR.puts "Could not find ConferenceWorkstream with name '#{name}'"
    return
  end
  @old_locale = I18n.locale
  I18n.locale = locale
  cw.name = local_name
  cw.byline = local_byline
  cw.language = local_language
  cw.save!
  I18n.locale = @old_locale
end

def new_ws(conference_id,priority_sort,name,byline=nil,language='')
  byline = nil if byline == ''
  language = '' if language == 'English'
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

#new_ws(@conference_id,@sort += 1,'Youth as empowered civil society actors','An interactive workshop by youth for youth who want to actively shape our future societies','English')
#new_ws(@conference_id,@sort += 1,'Empowering Women\'s Leadership within Civil Society','','Spanish, with interpretation')
#new_ws(@conference_id,@sort += 1,'Building Trust between Generations, Communities and Cultures','','English')
#new_ws(@conference_id,@sort += 1,'Pedagogy for the Child as Global Citizen','Children & Youth as Teachers','English')
#new_ws(@conference_id,@sort += 1,'Social Practice in the Making','An interactive, experiential learning experience with Critical Mass Foundation','English')
#new_ws(@conference_id,@sort += 1,'Media and its responsibilities','Creating a perception of the "Other"','English')
#new_ws(@conference_id,@sort += 1,'Anti-discrimination and religious diversity','','English')

new_ws(@conference_id,@sort += 1,'Youth as empowered civil society actors','','English')
new_ws(@conference_id,@sort += 1,'Empowering Women\'s Leadership within Civil Society','','Spanish, with interpretation')
new_ws(@conference_id,@sort += 1,'Building Trust between Generations, Communities and Cultures','','English')
new_ws(@conference_id,@sort += 1,'Pedagogy for the Child as Global Citizen','','English')
new_ws(@conference_id,@sort += 1,'Social Practice in the Making','','English')
new_ws(@conference_id,@sort += 1,'Media and its responsibilities','','English')
new_ws(@conference_id,@sort += 1,'Anti-discrimination and religious diversity','','English')

update_ws('Youth as empowered civil society actors','fr','Les jeunes, acteurs responsables de la société civile',nil,'Anglais')
update_ws('Empowering Women\'s Leadership within Civil Society','fr','Encourager le leadership des femmes dans la société civile','','animé en espagnol, avec interprétation')
update_ws('Building Trust between Generations, Communities and Cultures','fr','Instaurer la confiance entre les générations, les communautés et les  cultures',nil,'Anglais')
update_ws('Pedagogy for the Child as Global Citizen','fr','Pédagogie pour des enfants citoyens du monde',nil,'Anglais')
update_ws('Social Practice in the Making','fr','Mise en place d’une pratique sociale',nil,'Anglais')
update_ws('Media and its responsibilities','fr','La responsabilité des médias',nil,'Anglais')
update_ws('Anti-discrimination and religious diversity','fr','Diversité religieuse et lutte contre la discrimination',nil,'Anglais')

update_ws('Youth as empowered civil society actors','de','Jugend als aktive Mitglieder einer Zivilgesellschaf',nil,'Englisch')
update_ws('Empowering Women\'s Leadership within Civil Society','de','Stärkung der Rolle von Frauen in der Zivilgesellschaft und Führung durch Frauen',nil,'Spanisch mit Übersetzung')
update_ws('Building Trust between Generations, Communities and Cultures','de','Vertrauensbildung zwischen Generationen',nil,'Englisch')
update_ws('Pedagogy for the Child as Global Citizen','de','Pädagogik für das Kind als Weltbürger',nil,'Englisch')
update_ws('Social Practice in the Making','de','So entsteht praktisches Handeln',nil,'Englisch')
update_ws('Media and its responsibilities','de','Die Verantwortung der Medien',nil,'Englisch')
update_ws('Anti-discrimination and religious diversity','de','Anti-Diskriminierung und religiöse Vielfalt',nil,'Englisch')

@conference_id = Conference.with_translations.where("session_group_id = 12 and name = 'Trust and integrity in the global economy'").first.id
@sort = 0

#new_ws(@conference_id,@sort += 1,'Reshaping Business','Reshaping Business around Core Values','English')
#new_ws(@conference_id,@sort += 1,'Food and Development','Food and the New Development Paradigm: Farmers, consumers and business protecting our common environmental future.','English')
#new_ws(@conference_id,@sort += 1,'Sustainable World','Leading Change for a Sustainable World. <br/>&nbsp;&nbsp;If you want to participate this workstream please read <a href="http://www.caux.iofc.org/sites/all/files/LCSW%20application%20form.pdf">this document</a>.','English')
#new_ws(@conference_id,@sort += 1,'Leadership','Authentic Self-Leadership','English')
#new_ws(@conference_id,@sort += 1,'Integral Economy','Integral Economy and Integral Society','English')
#new_ws(@conference_id,@sort += 1,'Learning Society','Creating a Learning Society','English')

new_ws(@conference_id,@sort += 1,'Business Work Stream','','English')
new_ws(@conference_id,@sort += 1,'Food Sustainability Network','','English')
new_ws(@conference_id,@sort += 1,'Leading change for a Sustainable World','If you want to participate this workstream please read <a href="http://www.caux.iofc.org/sites/all/files/LCSW%20application%20form.pdf">this document</a>.','English')
new_ws(@conference_id,@sort += 1,'Authentic Self-Leadership','','English')
new_ws(@conference_id,@sort += 1,'Integral Economy','','English')
new_ws(@conference_id,@sort += 1,'Creating the Learning Society','','English')

update_ws('Business Work Stream','fr','Remodeler le monde des affaires avec des valeurs essentielles',nil,'Anglais')
update_ws('Food Sustainability Network','fr','L\'alimentation et le nouveau paradigme du développement',nil,'Anglais')
update_ws('Leading change for a Sustainable World','fr','Conduire le changement pour un monde durable','pour participer à cet atelier, merci de lire et remplir <a href="http://www.caux.iofc.org/sites/all/files/LCSW%20application%20form.pdf">ce document .PDF (en anglais)</a>','Anglais')
update_ws('Authentic Self-Leadership','fr','Vers un « Self Leadership » authentique',nil,'Anglais')
update_ws('Integral Economy','fr','Economie intégrante et société intégrante',nil,'Anglais')
update_ws('Creating the Learning Society','fr','Créer une société de l’apprentissage',nil,'Anglais')

update_ws('Business Work Stream','de','Rückbesinnung auf Grundwerte des Unternehmertums',nil,'Englisch')
update_ws('Food Sustainability Network','de','Nahrung und das neue Entwicklungsmodell',nil,'Englisch')
update_ws('Leading change for a Sustainable World','de','Verantwortung übernehmen –für eine nachhaltige Zukunft','Um an diesem Workstream teilzunehmen, lesen Sie bitte <a href="http://www.caux.iofc.org/sites/all/files/LCSW%20application%20form.pdf">folgendes Dokument (PDF - Englisch)</a>','Englisch')
update_ws('Authentic Self-Leadership','de','Authenthisches "Self-Leadership"',nil,'Englisch')
update_ws('Integral Economy','de','Integrale Wirtschaft und Integrale Gesellschaft',nil,'Englisch')
update_ws('Creating the Learning Society','de','Eine lernende Gesellschaft kreieren',nil,'Englisch')

@conference_id = Conference.with_translations.where("session_group_id = 12 and name = 'The dynamics of being a change-maker'").first.id
@sort = 0

new_ws(@conference_id,@sort += 1,'Creators of Peace - Creators of Peace Circle','','English')
new_ws(@conference_id,@sort += 1,'Creators of Peace - Facilitating the Circle','','English')
new_ws(@conference_id,@sort += 1,'Connecting communities through trustbuilding','','English')
new_ws(@conference_id,@sort += 1,'The heart of effective leadership','','English')
new_ws(@conference_id,@sort += 1,'Foundations for freedom','','English')
new_ws(@conference_id,@sort += 1,'Life matters course','','English')

update_ws('Creators of Peace - Creators of Peace Circle','fr','Femmes - Artisans de paix: Cercle de paix',nil,'Anglais')
update_ws('Creators of Peace - Facilitating the Circle','fr','Femmes - Artisans de paix: Animer un Cercle',nil,'Anglais')
update_ws('Connecting communities through trustbuilding','fr','Rapprocher les communautés en renforçant la confiance',nil,'Anglais')
update_ws('The heart of effective leadership','fr','Au cœur du leadership effectif',nil,'Anglais')
update_ws('Foundations for freedom','fr','Fondements de la liberté',nil,'Anglais')
update_ws('Life matters course','fr','Votre vie à de l\'importance',nil,'Anglais')

update_ws('Creators of Peace - Creators of Peace Circle','de','Creators of Peace: « Peace Circles » erleben ',nil,'Englisch')
update_ws('Creators of Peace - Facilitating the Circle','de','Creators of Peace: « Peace Circles » moderieren',nil,'Englisch')
update_ws('Connecting communities through trustbuilding','de','Gesellschaften durch Vertrauen vereinen',nil,'Englisch')
update_ws('The heart of effective leadership','de','Die Basis erfolgreicher Führung',nil,'Englisch')
update_ws('Foundations for freedom','de','Grundlagen für die Freiheit',nil,'Englisch')
update_ws('Life matters course','de','Ihr Leben zählt',nil,'Englisch')

I18n.locale = 'en'

c = Conference.with_translations.where("session_group_id = 12 and name = 'One wholesome World - a global gathering'").first
c.byline = 'Only by invitation'
I18n.locale = 'fr'
c.name = 'One wholesome World - un rassemblement mondial'
c.byline = 'Uniquement sur invitation'
I18n.locale = 'de'
c.name = 'One wholesome World - Ein globales Treffen'
c.byline = 'Teilnahme nur auf persönliche Einladung.'
c.save

I18n.locale = 'en'

c = Conference.with_translations.where("session_group_id = 12 and name = 'ICP'").first
c.byline = 'Only by invitation'
I18n.locale = 'fr'
c.byline = 'Uniquement sur invitation'
I18n.locale = 'de'
c.byline 'nur auf Einladung'
c.save

I18n.locale = 'en'
c = Conference.with_translations.where("session_group_id = 12 and name = 'Global Assembly'").first
I18n.locale = 'fr'
c.name = 'Assemblée mondiale d\'I&C'
I18n.locale = 'de'
c.name = 'IofC Global Assembly'
c.save


I18n.locale = 'en'
tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Caux Scholars Program','12').first
tp.byline = 'Please note that this is not the application form for the Caux Scholars Program.<br/>This is to register for those who have already applied and have been accepted.'
I18n.locale = 'fr'
tp.byline = 'Uniquement pour les candidats déjà acceptés dans le programme.'
I18n.locale = 'de'
tp.byline = 'Anmeldung nur für Teilnehmende welche bereits für das Programm angenommen wurden.'
tp.save

I18n.locale = 'en'
tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Caux Interns Program - Session 1','12').first
tp.byline = 'Please note that this is not the application form for the Caux Interns Program.<br/>This is to register for those who have already applied and have been accepted.'
I18n.locale = 'fr'
tp.byline = 'Uniquement pour les candidats déjà acceptés dans le programme.'
I18n.locale = 'de'
tp.byline = 'Anmeldung nur für Teilnehmende welche bereits für das Programm angenommen wurden.'
tp.save

I18n.locale = 'en'
tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Caux Interns Program - Session 2','12').first
tp.byline = 'Please note that this is not the application form for the Caux Interns Program.<br/>This is to register for those who have already applied and have been accepted.'
I18n.locale = 'fr'
tp.byline = 'Uniquement pour les candidats déjà acceptés dans le programme.'
I18n.locale = 'de'
tp.byline = 'Anmeldung nur für Teilnehmende welche bereits für das Programm angenommen wurden.'
tp.save

I18n.locale = 'en'
tp = TrainingProgram.with_translations.where('name = ? and session_group_id = ?','Week of International Community','12').first
tp.byline = 'Preparation Week - no conference!';
I18n.locale = 'fr'
tp.name = 'Vivre une expérience internationale'
tp.byline = 'Semaine de préparation - pas une conference!'
I18n.locale = 'de'
tp.name = 'Vorbereitungswoche'
tp.save


