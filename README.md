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
NOTE: **These procedures are subject to change** while both the API and this library are in an early state.

A client must be initialized with your client ID, and optionally an OAuth access token.
```
client = Twitch::Client.new client_id: "YOUR_CLIENT_ID"
```
The retrieval methods take in a hash equal to the GET parameters of the API endpoint, and return an typed array of the items requested.
```
# Get top live streams
client.get_streams
# Get a single user
client.get_users({login: "disguisedtoasths"}).first
# Find some games
# (use an array for up to 100 of most queryable resources)
client.get_games({name: ["Heroes of the Storm", "Super Mario Odyssey"]})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Upon reaching version 0.1.0, bug reports and pull requests will be welcome on GitHub at https://github.com/mauricew/ruby-twitch-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
