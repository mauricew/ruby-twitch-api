# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['TWITCH_CLIENT_ID'] ||= 'test_client_id'
ENV['TWITCH_CLIENT_SECRET'] ||= 'test_client_secret'
ENV['TWITCH_ACCESS_TOKEN'] ||= 'test_access_token'
ENV['TWITCH_REFRESH_TOKEN'] ||= 'test_refresh_token'
ENV['TWITCH_APPLICATION_ACCESS_TOKEN'] ||= 'test_application_access_token'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
end

# require 'webmock/rspec'
require 'vcr'

VCR.configure do |vcr_config|
  vcr_config.cassette_library_dir = "#{__dir__}/cassettes"
  vcr_config.configure_rspec_metadata!
  vcr_config.hook_into :faraday

  vcr_config.filter_sensitive_data('<CLIENT_ID>') do
    ENV['TWITCH_CLIENT_ID']
  end

  vcr_config.filter_sensitive_data('<CLIENT_SECRET>') do
    ENV['TWITCH_CLIENT_SECRET']
  end

  vcr_config.filter_sensitive_data('<ACTUAL_ACCESS_TOKEN>') do
    ENV['TWITCH_ACCESS_TOKEN']
  end

  vcr_config.filter_sensitive_data('<ACTUAL_REFRESH_TOKEN>') do
    ENV['TWITCH_REFRESH_TOKEN']
  end

  vcr_config.filter_sensitive_data('<ACTUAL_APPLICATION_ACCESS_TOKEN>') do
    ENV['TWITCH_APPLICATION_ACCESS_TOKEN']
  end

  vcr_config.filter_sensitive_data('<NEW_APPLICATION_ACCESS_TOKEN>') do |interaction|
    JSON.parse(interaction.response.body)['access_token']
  end

  vcr_config.filter_sensitive_data('<AUTHORIZATION_HEADER>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end
end

require_relative '../lib/twitch-api'
