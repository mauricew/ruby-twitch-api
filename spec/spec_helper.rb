require "bundler/setup"
require "webmock/rspec"
require "vcr"
require "twitch-api"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/cassettes'
    c.filter_sensitive_data('<API KEY>') { ENV['TWITCH_CLIENT_ID'] }
    c.hook_into :webmock
  end

end
