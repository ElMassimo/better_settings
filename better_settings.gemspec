require File.expand_path('../lib/better_settings/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'better_settings'
  s.version = BetterSettings::VERSION
  s.authors = ['Máximo Mussini']
  s.email = ['maximomussini@gmail.com']
  s.summary = 'Settings for Rails applications: simple, immutable, better.'
  s.description = 'Settings solution for Rails applications that can read YAML files (ERB-enabled) and allows to access using method calls.'
  s.homepage = 'https://github.com/ElMassimo/better_settings'
  s.license = 'MIT'
  s.extra_rdoc_files = ['README.md']
  s.files = Dir.glob('{lib}/**/*.rb') + %w(README.md)
  s.test_files   = Dir.glob('{spec}/**/*.rb')
  s.require_path = 'lib'

  s.required_ruby_version = Gem::Requirement.new('>= 2.2')

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-given', '~> 3.0'
end
