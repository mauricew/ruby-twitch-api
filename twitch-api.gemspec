# frozen_string_literal: true

require_relative 'lib/twitch/version'

Gem::Specification.new do |spec|
  spec.name          = 'twitch-api'
  spec.version       = Twitch::VERSION
  spec.authors       = ['Maurice Wahba']
  spec.email         = ['maurice.wahba@gmail.com']

  spec.summary       = 'Ruby client for the Twitch Helix API.'
  spec.homepage      = 'https://github.com/mauricew/ruby-twitch-api'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 2.5'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt']

  spec.add_dependency 'faraday', '~> 1.0'
  spec.add_dependency 'faraday_middleware', '~> 1.0'
  spec.add_dependency 'twitch_oauth2', '~> 0.3.0'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'codecov', '~> 0.3.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.3'
  spec.add_development_dependency 'rubocop-performance', '~> 1.8'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
  spec.add_development_dependency 'simplecov', '~> 0.20.0'
  spec.add_development_dependency 'vcr', '~> 6.0'
end
