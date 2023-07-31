[![Gem](https://img.shields.io/gem/v/twitch-api.svg)](https://rubygems.org/gems/twitch-api)
[![Downloads](https://img.shields.io/gem/dt/twitch-api.svg)](https://rubygems.org/gems/twitch-api)
[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/mauricew/ruby-twitch-api)](https://cirrus-ci.com/github/mauricew/ruby-twitch-api)
[![License](https://img.shields.io/github/license/mauricew/ruby-twitch-api.svg)](LICENSE.txt)

# Ruby Twitch API

This library is a Ruby implementation of the [Twitch Helix API](https://dev.twitch.tv/docs/api).

The goal is to provide access for the newest supported APIs provided by Twitch,
while keeping extensibility for their future expansion.
These are still in development, as is this library which should remain in pace with changes made.

Guaranteed supported APIs include:

*   Helix REST (full rolling support)
*   Helix Webhooks (coming soon)

The future may bring:

*   PubSub
*   TMI/chat

These will not be considered:

*   [Twitch Kraken API](https://github.com/dustinlakin/twitch-rb)
*   [Twitch GraphQL API](https://github.com/mauricew/twitch-graphql-api)

## Installation

Add to your application's Gemfile:

```ruby
# If you want a full release
gem 'twitch-api'
# If you want to live on the edge
gem 'twitch-api', :git => 'https://github.com/mauricew/ruby-twitch-api'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install twitch-api
```

## Usage

### Authentication

[Twitch documentation](https://dev.twitch.tv/docs/authentication).

This gem uses [`twitch_oauth2` gem](https://github.com/AlexWayfer/twitch_oauth2)
for authorization and authentication, you can read more detailed documentation there
(but it's pretty simple).

The goal is in an object with credentials and re-using it between different gems,
for example for API and for chat, or for the old API and the new one.
Also a logic for tokens validation and refreshing is encapsulated in it.

One of references is [this JavaScript set of libraries](https://github.com/d-fischer/twitch).

#### Client (application) flow

This is easier flow with limited (non-personal) access.

```ruby
tokens = TwitchOAuth2::Tokens.new(
  client: {
    client_id: client_id,
    client_secret: client_secret
  },

  ## this is default
  # token_type: :application,

  ## this can be required by some Twitch end-points
  # scopes: scopes,

  ## if you already have ones
  # access_token: access_token
)

twitch_client = Twitch::Client.new(tokens: tokens)
```

#### Authorization (user) flow

This is flow required for user-specific actions.

If there are no `access_token` and `refresh_token` in `:tokens`,
`TwitchOAuth2::AuthorizeError` will be raised with `#link`.

If you have a web-application with N users, you can redirect them to this link
and use `redirect_uri` to your application for callbacks.

Otherwise, if you have something like CLI tool, you can print instructions with a link for user.

Then you can use `tokens.code = 'a code from params in redirect uri'`
and it'll store new `:access_token` and `:refresh_token`.

```ruby
tokens = TwitchOAuth2::Tokens.new(
  client: {
    client_id: client_id,
    client_secret: client_secret,

    ## `localhost` by default, can be your application end-point
    # redirect_uri: redirect_uri
  },

  token_type: :user,

  ## this can be required by some Twitch end-points
  # scopes: scopes,

  ## if you already have these
  # access_token: access_token,
  # refresh_token: refresh_token
)

twitch_client = Twitch::Client.new(tokens: tokens)
```

#### After initialization

If you've passed `refresh_token` to initialization and your `access_token` is invalid,
requests that require `access_token` will automatically refresh it.

You can access tokens:

```ruby
twitch_client.tokens # => `TwitchOAuth2::Tokens` instance
twitch_client.tokens.access_token # => 'abcdef'
twitch_client.tokens.refresh_token # => 'ghijkl'
```

### Calls

Because data may change for certain endpoints, there is also the raw response
for any request called.

Retrieval methods take in a hash equal to the parameters of the API endpoint,
and return a response object containing the data and other associated request information:

*   **data** is the data you would get back. Even if it's an array of one object,
    it remains the same as what comes from the API.
*   **rate_limit** and associated fields contain API request limit information.
    Clip creation counts for a second limit (duration currently unknown).
*   **pagination** is a hash that appears when data can be traversed,
    and contains one member (*cursor*) which lets you paginate through certain requests.
*   **raw** is the raw HTTP response data.

```ruby
# Get top live streams
client.get_streams.data
# Get a single user
client.get_users({login: "disguisedtoasths"}).data.first
# Find some games
# (use an array for up to 100 of most queryable resources)
client.get_games({name: ["Heroes of the Storm", "Super Mario Odyssey"]}).data
```

### Error handling

An `APIError` is raised whenever an HTTP error response is returned.
Rescue it to access the body of the response, which should include an error message.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
(Tests require a Twitch Client ID; since cassettes exist you can use any value.)

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/mauricew/ruby-twitch-api).
