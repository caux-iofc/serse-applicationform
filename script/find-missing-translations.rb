#!/usr/bin/env ruby

require 'pp'
require 'yaml'

require 'iconv'

# We want to convert from ISO-8859-1 to UTF-8
c = Iconv.new('UTF-8', 'ISO-8859-1')

STDERR.puts Dir.getwd()

english = YAML::load( File.open( '../config/locales/en-applicationform.yml' ) )
french = YAML::load( File.open( '../config/locales/fr-applicationform.yml' ) )
german = YAML::load( File.open( '../config/locales/de-applicationform.yml' ) )

english = english['en']
french = french['fr']
german = german['de']

missing_french = Hash.new()
missing_german = Hash.new()

english.each do |k,v|
  if not french.has_key?(k) then
    missing_french[k] = v
  end
  if not german.has_key?(k) then
    missing_german[k] = v
  end
end

STDERR.puts "French translations missing: #{missing_french.count}"
STDERR.puts "German translations missing: #{missing_german.count}"

missing_french = { 'fr' => missing_french }
missing_german = { 'de' => missing_german }

File.open('../config/locales/fr-missing.yml', 'w') do |out|
  out.write(missing_french.to_yaml)
end
File.open('../config/locales/de-missing.yml', 'w') do |out|
  out.write(missing_german.to_yaml)
end

