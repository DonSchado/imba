require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'check all the things before you commit'
task check: :default do
  system 'rubocop'
  system 'flog lib'
end
