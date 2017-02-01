#!/usr/bin/env ruby

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def new_diet(sort,en,fr=en,de=en)
  I18n.locale = :en
  d = Diet.find_by_name(en)
  if d.nil? then
    d = Diet.new()
  end
  d.priority_sort = sort

  d.name = en
  I18n.locale = :fr
  d.name = fr
  I18n.locale = :de
  d.name = de
  d.save!
end

sort = 0
new_diet(sort += 1,'Vegetarian (includes eggs and dairy products)','Végétarien (comprend des œufs et des produits laitiers)','Vegetarisch (inclusive Eier und Michprodukte)')
#new_diet(sort += 1,'Vegan','Végétalien','Vegan')
new_diet(sort += 1,'Halal')
#new_diet(sort += 1,'Ramadan','Ramadan','Ramadan')
new_diet(sort += 1,'Gluten free','Sans gluten','Glutenfrei')
new_diet(sort += 1,'Lactose free','Sans lactose','Laktosefrei')
new_diet(sort += 1,'Low salt','Sans sel','Salzlos')
new_diet(sort += 1,'Onion / garlic free','Sans oignon / ail','Ohne Zwiebeln / Knoblauch')
#new_diet(sort += 1,'Other','Autre','Anderes')

