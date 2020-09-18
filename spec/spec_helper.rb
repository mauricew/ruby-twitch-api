# frozen_string_literal: true

require 'webmock/rspec'
require 'vcr'
require_relative '../lib/twitch-api'

ENV['TWITCH_CLIENT_ID'] ||= 'test'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  VCR.configure do |vcr_config|
    vcr_config.cassette_library_dir = 'spec/fixtures/cassettes'
    vcr_config.filter_sensitive_data('<API KEY>') { ENV['TWITCH_CLIENT_ID'] }
    vcr_config.hook_into :webmock
  end
end
