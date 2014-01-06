require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :check

desc 'check all the things before you commit'
task check: :spec do
  system 'rubocop'
  system 'flog lib'
end
