# frozen_string_literal: true

require 'pry-byebug'

require 'simplecov'

if ENV['CI']
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.start

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
    ENV.fetch('TWITCH_CLIENT_ID')
  end

  vcr_config.filter_sensitive_data('<CLIENT_SECRET>') do
    ENV.fetch('TWITCH_CLIENT_SECRET')
  end

  vcr_config.filter_sensitive_data('<ACTUAL_ACCESS_TOKEN>') do
    ENV.fetch('TWITCH_ACCESS_TOKEN')
  end

  vcr_config.filter_sensitive_data('<ACTUAL_REFRESH_TOKEN>') do
    ENV.fetch('TWITCH_REFRESH_TOKEN')
  end

  vcr_config.filter_sensitive_data('<ACTUAL_APPLICATION_ACCESS_TOKEN>') do
    ENV.fetch('TWITCH_APPLICATION_ACCESS_TOKEN')
  end

  vcr_config.filter_sensitive_data('<NEW_ACCESS_TOKEN>') do |interaction|
    if interaction.response.headers['content-type']&.include? 'application/json'
      JSON.parse(interaction.response.body)['access_token']
    end
  end

  vcr_config.filter_sensitive_data('<NEW_REFRESH_TOKEN>') do |interaction|
    if interaction.response.headers['content-type']&.include? 'application/json'
      JSON.parse(interaction.response.body)['refresh_token']
    end
  end

  vcr_config.filter_sensitive_data('<CODE>') do |interaction|
    if interaction.request.uri == 'https://id.twitch.tv/oauth2/token'
      JSON.parse(interaction.request.body)['code']
    end
  end

  vcr_config.filter_sensitive_data('<AUTHORIZATION_HEADER>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end

  vcr_config.filter_sensitive_data('<TOKEN_USER_LOGIN>') do |interaction|
    if interaction.request.uri == 'https://id.twitch.tv/oauth2/validate'
      JSON.parse(interaction.response.body)['login']
    end
  end

  vcr_config.filter_sensitive_data('<TOKEN_USER_ID>') do |interaction|
    if interaction.request.uri == 'https://id.twitch.tv/oauth2/validate'
      JSON.parse(interaction.response.body)['user_id']
    end
  end
end

require_relative '../lib/twitch-api'
