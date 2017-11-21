# Ruby Twitch API (work in progress)

This library is a Ruby implementation of the [Twitch Helix API](https://dev.twitch.tv/docs/api).

## Installation
Ruby 2.1 or later is required.

Add this line to your application's Gemfile:

```ruby
gem 'twitch-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitch-api

## Usage
A client must be initialized with your client ID, and optionally an OAuth access token.
```
client = Twitch::Client.new client_id: "YOUR_CLIENT_ID"
```
The retrieval methods take in a hash equal to the GET parameters of the API endpoint, and return a response object containing the data and other associated request information:
* **data** is the data you would get back
* **rate_limit** contains the number of API requests that can be made in total within a 60-second window. See **rate_limit_remaining** and  **rate_limit_resets_at** to determine the current allowed rate.
* **pagination** (optional) is an hash that usually contains one member (*cursor*) which lets you pagniate through certain requests.
```
# Get top live streams
client.get_streams.data
# Get a single user
client.get_users({login: "disguisedtoasths"}).data.first
# Find some games
# (use an array for up to 100 of most queryable resources)
client.get_games({name: ["Heroes of the Storm", "Super Mario Odyssey"]}).data
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mauricew/ruby-twitch-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
