# frozen_string_literal: true

require 'faraday'
require 'faraday/parse_dates'
require 'faraday/retry'
require 'twitch_oauth2'

require_relative 'response'

require_relative 'api_error'
require_relative 'bits_leader'
require_relative 'channel'
require_relative 'clip'
require_relative 'entitlement_grant_url'
require_relative 'extension'
require_relative 'game'
require_relative 'game_analytic'
require_relative 'moderation_event'
require_relative 'moderator'
require_relative 'stream'
require_relative 'stream_marker'
require_relative 'stream_metadata'
require_relative 'stream_tag'
require_relative 'subscription'
require_relative 'user'
require_relative 'user_ban'
require_relative 'user_follow'
require_relative 'video'

module Twitch
  # Core class for requests
  class Client
    # Base connection to Helix API.
    CONNECTION = Faraday.new(
      'https://api.twitch.tv/helix', {
        headers: { 'User-Agent': "twitch-api ruby client #{Twitch::VERSION}" }
      }
    ) do |faraday|
      faraday.request :retry,
        exceptions: [*Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS, Faraday::ConnectionFailed]

      faraday.response :parse_dates

      faraday.request :json
      faraday.response :json
    end

    attr_reader :tokens

    # Initializes a Twitch client.
    #
    # - tokens [TwitchOAuth2::Tokens] Tokens object with their refreshing logic inside.
    # All client and authentication information (`client_id`, `:scopes`, etc.) stores there.
    def initialize(tokens:)
      @tokens = tokens

      CONNECTION.headers['Client-ID'] = self.tokens.client.client_id

      renew_authorization_header
    end

    def create_clip(options = {})
      initialize_response Clip, post('clips', options)
    end

    def create_entitlement_grant_url(options = {})
      initialize_response EntitlementGrantUrl, post('entitlements/upload', options)
    end

    def get_clips(options = {})
      initialize_response Clip, get('clips', options)
    end

    def get_bits_leaderboard(options = {})
      initialize_response BitsLeader, get('bits/leaderboard', options)
    end

    require_relative 'client/extensions'
    include Extensions

    require_relative 'client/games'
    include Games

    require_relative 'client/moderation'
    include Moderation

    require_relative 'client/stream_tags'
    include StreamTags

    require_relative 'client/streams'
    include Streams

    require_relative 'client/subscriptions'
    include Subscriptions

    def get_videos(options = {})
      initialize_response Video, get('videos', options)
    end

    require_relative 'client/users'
    include Users

    ## https://dev.twitch.tv/docs/api/reference#get-channel-information
    def get_channels(options = {})
      initialize_response Channel, get('channels', options)
    end

    ## https://dev.twitch.tv/docs/api/reference/#search-channels
    def search_channels(options = {})
      initialize_response Channel, get('search/channels', options)
    end

    ## https://dev.twitch.tv/docs/api/reference#modify-channel-information
    def modify_channel(options = {})
      response = patch('channels', options)

      return true if response.body.empty?

      response.body
    end

    private

    def initialize_response(data_class, http_response)
      Response.new(data_class, http_response: http_response)
    end

    %w[get post put patch].each do |http_method|
      define_method http_method do |resource, params|
        request http_method, resource, params
      end
    end

    def renew_authorization_header
      CONNECTION.headers['Authorization'] = "Bearer #{tokens.access_token}"
    end

    def request(http_method, resource, params)
      http_response = CONNECTION.public_send http_method, resource, params

      if http_response.status == 401
        renew_authorization_header

        http_response = CONNECTION.public_send http_method, resource, params
      end

      return http_response if http_response.success?

      raise APIError.new(http_response.status, http_response.body)
    end
  end
end
