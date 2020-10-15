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

  spec.required_ruby_version = '>= 2.3'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 0.12.2'
  spec.add_dependency 'faraday_middleware', '~> 0.12'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.0'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.1'
end
