require 'simplecov'
require 'coveralls'
SimpleCov.start { add_filter '/spec/' }
Coveralls.wear!

require 'better_settings'
require 'rspec/given'
require 'pry-byebug'
