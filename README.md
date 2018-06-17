[![Gem](https://img.shields.io/gem/v/twitch-api.svg)](https://rubygems.org/gems/twitch-api)
[![Downloads](https://img.shields.io/gem/dt/twitch-api.svg)](https://rubygems.org/gems/twitch-api)
[![Travis](https://img.shields.io/travis/mauricew/ruby-twitch-api.svg)](https://travis-ci.org/mauricew/ruby-twitch-api)
[![License](https://img.shields.io/github/license/mauricew/ruby-twitch-api.svg)]()
# Ruby Twitch API

This library is a Ruby implementation of the [Twitch Helix API](https://dev.twitch.tv/docs/api).

The goal is to provide access for the newest supported APIs provided by Twitch, while keeping extensiblity for their future expansion. These are still in development, as is this library which should remain in pace with changes made.

Guaranteed supported APIs include:
* Helix REST (full rolling support)
* Helix Webhooks (coming soon)

The future may bring:
* Authentication
* PubSub
* TMI/chat

These will not be considered:
* Twitch kraken API
* [Twitch GraphQL API](https://github.com/mauricew/twitch-graphql-api)

## Installation
Ruby 2.1 or later compatibility is guaranteed, however the target is 2.0 and above.

Add to your application's Gemfile:

```ruby
# If you want a full release
gem 'twitch-api'
# If you want to live on the edge
gem 'twitch-api', :git => 'https://github.com/mauricew/ruby-twitch-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitch-api

## Usage
A client must be initialized with your client ID or bearer access token.
```
client = Twitch::Client.new(client_id: "YOUR_CLIENT_ID")
# or
client = Twitch::Client.new(access_token: "YOUR_ACCESS_TOKEN")
```
Because data may change for certain endpoints, there is also a keyword parameter called `with_raw` that returns the raw response for any request called.

Retrieval methods take in a hash equal to the parameters of the API endpoint, and return a response object containing the data and other associated request information:
* **data** is the data you would get back. Even if it's an array of one object, it remains the same as what comes from the API.
* **rate_limit** and associated fields contain API request limit information. Clip creation counts for a second limit (duration currently unknown).
* **pagination** is a hash that appears when data can be traversed, and contains one member (*cursor*) which lets you pagniate through certain requests.
* **raw** is the raw HTTP response data when `with_raw` is true in the client.
```
# Get top live streams
client.get_streams.data
# Get a single user
client.get_users({login: "disguisedtoasths"}).data.first
# Find some games
# (use an array for up to 100 of most queryable resources)
client.get_games({name: ["Heroes of the Storm", "Super Mario Odyssey"]}).data
```

### Error handling
An *ApiError* is raised whenever an HTTP error response is returned.
Rescue it to access the body of the response, which should include an error message.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. (Tests require a Twitch Client ID; since cassettes exist you can use any value.)

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mauricew/ruby-twitch-api.
