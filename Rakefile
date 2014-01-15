require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'active_record'
require 'yaml'
require 'logger'

RSpec::Core::RakeTask.new(:spec)

task default: :check

desc 'check all the things before you commit'
task check: :spec do
  system 'rubocop'
  system 'flog lib'
end

desc 'migrate database'
task migrate: :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil )
end

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('db/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end
