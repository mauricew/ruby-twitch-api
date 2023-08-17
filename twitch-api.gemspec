# frozen_string_literal: true

require_relative 'lib/twitch/version'

Gem::Specification.new do |spec|
  spec.name          = 'twitch-api'
  spec.version       = Twitch::VERSION
  spec.authors       = ['Maurice Wahba', 'Alexander Popov']
  spec.email         = ['maurice.wahba@gmail.com', 'alex.wayfer@gmail.com']

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

  spec.required_ruby_version = '>= 2.7', '< 4'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt']

  spec.add_dependency 'faraday', '~> 2.3'
  spec.add_dependency 'faraday-parse_dates', '~> 0.1.1'
  spec.add_dependency 'faraday-retry', '~> 2.0'
  spec.add_dependency 'twitch_oauth2', '~> 0.5.0'
end
