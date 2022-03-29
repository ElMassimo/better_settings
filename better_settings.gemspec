# frozen_string_literal: true

require File.expand_path('lib/better_settings/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'better_settings'
  s.version = BetterSettings::VERSION
  s.authors = ['Máximo Mussini']
  s.email = ['maximomussini@gmail.com']
  s.summary = 'Settings for Ruby applications: fast, immutable, better.'
  s.description = 'Settings solution for Ruby or Rails applications that can read ERB-enabled YAML files. Safe, performant, with friendly error messages, and no dependencies.'
  s.homepage = 'https://github.com/ElMassimo/better_settings'
  s.license = 'MIT'
  s.extra_rdoc_files = ['README.md']
  s.files = Dir.glob('{lib}/**/*.rb') + %w[README.md]
  s.test_files   = Dir.glob('{spec}/**/*.rb')
  s.require_path = 'lib'

  s.required_ruby_version = Gem::Requirement.new('>= 3.1.0')

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-given', '~> 3.0'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov', '< 0.18'
end
