# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imba/version'

Gem::Specification.new do |spec|
  spec.name          = 'imba'
  spec.version       = Imba::VERSION
  spec.authors       = ['Marco Schaden']
  spec.email         = ['ms@donschado.de']
  spec.summary       = %q{Imba is a command-line application to manage movies.}
  spec.description   = %q{With Imba you can manage your movies by meta information (like rating, genre, year) from IMDB and play on your Apple TV through Airplay (given a simple file structure).}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.1'
  spec.add_development_dependency 'rspec-pride', '~> 2.2.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.2.3'
  spec.add_development_dependency 'pry', '~> 0.9.12.4'
  spec.add_development_dependency 'pry-rescue', '~> 1.2.0'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9.1'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'flog'

  spec.add_runtime_dependency 'imdb', '~> 0.8.0'
  spec.add_runtime_dependency 'airplay', '~> 1.0.2'
end
