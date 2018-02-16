#!/usr/bin/env ruby

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def new_diet(sort,menu,code,en,fr=en,de=en)
  I18n.locale = :en
  d = Diet.where(:name => en).first
  if d.nil? then
    d = Diet.new()
  end
  d.priority_sort = sort

  d.menu = menu
  d.code = code

  d.name = en
  I18n.locale = :fr
  d.name = fr
  I18n.locale = :de
  d.name = de
  d.save!
end

sort = 0

new_diet(sort += 1,1,'0','standard (meat, fish or vegetarian)','standard (viande, poisson ou végétarien)','Standard (Fleisch, Fisch oder vegetarisch)')
new_diet(sort += 1,1,'1','vegetarian','végétarien','Vegetarisch')
new_diet(sort += 1,1,'2','vegan','végétalien','Vegan')
new_diet(sort += 1,1,'3','halal','halal','Halal')

new_diet(sort += 1,0,'LF','lactose free','sans lactose','Laktosefrei')
new_diet(sort += 1,0,'GF','gluten free','sans gluten','Glutenfrei')
new_diet(sort += 1,0,'LGF','lactose & gluten free','sans gluten & lactose','Gluten- und Laktosefrei')
new_diet(sort += 1,0,'M','other medical needs (please specify per email)','autres besoins médicaux (veuillez préciser par email)','andere medizinische Bedürfnisse (bitte per email präzisieren)')

