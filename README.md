# Ruby Twitch API (work in progress)

This library is a Ruby implementation of the [Twitch Helix API](https://dev.twitch.tv/docs/api).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twitch-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitch-api

## Usage
The initially available methods take in a hash equal to the GET parameters of the API endpoint, and return an typed array of the items requested.
```
client = Twitch::Client.new client_id: "YOUR_CLIENT_ID"
# Get top live streams
client.get_streams
# Get a single user
client.get_users({login: "disguisedtoasths"}).first
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Upon reaching version 0.1.0, bug reports and pull requests will be welcome on GitHub at https://github.com/mauricew/ruby-twitch-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
