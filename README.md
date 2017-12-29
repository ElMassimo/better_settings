BetterSettings [![Gem Version](https://img.shields.io/gem/v/better_settings.svg?colorB=e9573f)](https://rubygems.org/gems/better_settings) [![Build Status](https://travis-ci.org/ElMassimo/better_settings.svg)](https://travis-ci.org/ElMassimo/better_settings) [![Coverage Status](https://coveralls.io/repos/github/ElMassimo/better_settings/badge.svg?branch=master)](https://coveralls.io/github/ElMassimo/better_settings?branch=master) [![Inline docs](http://inch-ci.org/github/ElMassimo/better_settings.svg)](http://inch-ci.org/github/ElMassimo/better_settings) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ElMassimo/better_settings/blob/master/LICENSE.txt)
=======================================

A robust settings library that can read YML files and provide an immutable object allowing to access settings through method calls. Can be used in __any Ruby app__, __not just Rails__.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'better_settings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_settings

### Usage

#### 1. Define a class

Instead of defining a Settings constant for you, that task is left to you. Simply create a class in your application
that looks like:

```ruby
# app/models/settings.rb
class Settings < BetterSettings
  source Rails.root.join('config', 'application.yml'), namespace: Rails.env
end
```

#### 2. Create your settings

Notice above we specified an absolute path to our settings file called `application.yml`. This is just a typical YAML file.
Also notice above that we specified a namespace for our environment. A namespace is just an optional string that corresponds to a key in the YAML file.

Using a namespace allows us to change our configuration depending on our environment:

```yaml
# config/application.yml
defaults: &defaults
  port: 80
  mailer:
    root: www.example.com
  dynamic: <%= "Did you know you can use ERB inside the YML file? Env is #{ Rails.env }." %>

development:
  <<: *defaults
  port: 3000

test:
  <<: *defaults

production:
  <<: *defaults
```

#### 3. Access your settings

  >> Rails.env
  => "development"

  >> Settings.mailer
  => "#<Settings ... >"

  >> Settings.mailer.root
  => "www.example.com

  >> Settings.port
  => 3000

  >> Settings.dynamic
  => "Did you know you can use ERB inside the YML file? Env is development."

You can use these settings anywhere, for example in a model:

  class Post < ActiveRecord::Base
    self.per_page = Settings.pagination.posts_per_page
  end

### Advanced Setup ⚙
Name it `Settings`, name it `Config`, name it whatever you want. Add as many or as few as you like, read from as many files as necessary (nested keys will be merged).

We usually read a few optional files for the `development` and `test` environment, which allows each developer to override some settings in their own local environment (we git ignore `development.yml` and `test.yml`).

```ruby
# app/models/settings.rb
class Settings < BetterSettings
  source Rails.root.join('config', 'application.yml'), namespace: Rails.env
  source Rails.root.join('config', 'development.yml'), namespace: Rails.env, optional: true if Rails.env.development?
  source Rails.root.join('config', 'test.yml'), namespace: Rails.env, optional: true if Rails.env.test?
end
```
Our `application.yml` looks like this:
```yaml
# application.yml
defaults: &defaults
  auto_logout: false
  secret_key_base: 'fake_secret_key_base'

server_defaults: &server_defaults
  <<: *defaults
  auto_logout: true
  secret_key: <%= ENV['SECRET_KEY'] %>

development:
  <<: *defaults
  host: 'localhost'

test:
  <<: *defaults
  host: '127.0.0.1'

staging:
  <<: *server_defaults
  host: 'staging.example.com'

production:
  <<: *server_defaults
  host: 'example.com'
```
A developer might want to override some settings by defining a `development.yml` such as:
```yaml
development:
  auto_logout: true
````
The main advantage is that those changes won't be tracked by source control :smiley:

## Opinionated Design
After using [settingslogic](https://github.com/settingslogic/settingslogic) for a long time, we learned some lessons, which are distilled in the following decisions:
- __Immutability:__ Once created settings can't be modified.
- __No Optional Setings:__ Any optional setting can be modeled in a safer way, this library doesn't allow them.
- __Not Tied to a Source File:__ Useful to create multiple environment-specific files.
