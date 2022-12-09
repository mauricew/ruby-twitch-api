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

  github_uri = 'https://github.com/mauricew/ruby-twitch-api'

  spec.metadata = {
    'bug_tracker_uri' => "#{github_uri}/issues",
    'documentation_uri' => "http://www.rubydoc.info/gems/#{spec.name}/#{spec.version}",
    'homepage_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => github_uri
  }

  spec.required_ruby_version = '>= 2.6', '< 4'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt']

  spec.add_dependency 'faraday', '~> 2.3'
  spec.add_dependency 'faraday-parse_dates', '~> 0.1.1'
  spec.add_dependency 'faraday-retry', '~> 2.0'
  spec.add_dependency 'twitch_oauth2', '~> 0.4.0'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'codecov', '~> 0.6.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.40.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.8'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'vcr', '~> 6.0'
end
