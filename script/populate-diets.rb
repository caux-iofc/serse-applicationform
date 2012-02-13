#!/usr/bin/env ruby

# Default is development
production = ARGV[0] == "production"

verbose = ARGV[1] == "verbose"

ENV["RAILS_ENV"] = "production" if production

require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

def new_diet(sort,en,fr=en,de=en)
  d = Diet.new()
  d.priority_sort = sort

  I18n.locale = :en
  d.name = en
  I18n.locale = :fr
  d.name = fr
  I18n.locale = :de
  d.name = de
  d.save!
end

sort = 0
new_diet(sort += 1,'Halal')
new_diet(sort += 1,'Kosher','Kaser','Koscher')
new_diet(sort += 1,'Lactose free','Sans lactose','Laktosefrei')
new_diet(sort += 1,'Gluten free','Sans gluten','Glutenfrei')
new_diet(sort += 1,'Low fat','Sans matière grasse','Fettfrei')
new_diet(sort += 1,'Low salt','Sans sel','Salzlos')
new_diet(sort += 1,'Onion free','Sans oignon','Ohne Zwiebeln')
new_diet(sort += 1,'Other','Autre','Anderes')

