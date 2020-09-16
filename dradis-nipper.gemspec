$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'dradis/plugins/nipper/version'
version = Dradis::Plugins::Nipper::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'dradis-nipper'
  spec.version     = version
  spec.authors     = ['Daniel Martin']
  spec.email       = ['etd@nomejortu.com']
  spec.homepage    = 'http://dradisframework.org'
  spec.summary     = 'Nipper upload add-on for Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse reports from Nipper.'
  spec.license     = 'GPL-2'

  spec.files = `git ls-files`.split($\)
  spec.test_files  = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_dependency 'dradis-plugins', '~> 3.8'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '~> 0.5.2'
end
