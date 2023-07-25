# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in twitch-api.gemspec
gemspec

gem 'twitch_oauth2', github: 'AlexWayfer/twitch_oauth2', branch: 'tokens_object'

group :development do
  gem 'bundler', '~> 2.1'
  gem 'pry-byebug', '~> 3.9'
  gem 'rake', '~> 13.0'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov', '~> 0.22.0'
  gem 'simplecov-cobertura', '~> 2.1'
  gem 'vcr', '~> 6.0'
end

group :lint do
  gem 'rubocop', '~> 1.54.0'
  gem 'rubocop-performance', '~> 1.8'
  gem 'rubocop-rake', '~> 0.6.0'
  gem 'rubocop-rspec', '~> 2.22.0'
end
