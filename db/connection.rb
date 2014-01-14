require 'active_record'
require 'yaml'

config = YAML::load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(config)
