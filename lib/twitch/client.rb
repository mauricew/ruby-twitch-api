# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'twitch_oauth2'

require_relative 'response'
require_relative 'api_error'
require_relative 'bits_leader'
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
        headers: { "User-Agent": "twitch-api ruby client #{Twitch::VERSION}" }
      }
    ) do |faraday|
      faraday.request :json
      faraday.response :json
    end

    attr_reader :tokens

    # Initializes a Twitch client.
    #
    # - client_id [String] The client ID.
    # Used as the Client-ID header in a request.
    # - client_secret [String] The client secret.
    # Used for generation access tokens.
    # - redirect_uri [String] A redirect URI.
    # Used for redirection after successful authentication.
    # - scopes [Array<String>] Required scopes.
    # Used to specify permissions for the token.
    # - token_type [Symbol] Access Token type.
    # Used for behavior with given tokens and on requests.
    # - access_token [String] An access token.
    # Used as the Authorization header in a request.
    # - refresh_token [String] A refresh token.
    # Used for refreshing User Access Token.
    def initialize(options = {})
      client_id = options[:client_id]

      @oauth2_client = TwitchOAuth2::Client.new(
        client_id: client_id, **options.slice(:client_secret, :redirect_uri, :scopes)
      )

      @token_type = options.fetch(:token_type, :application)

      @tokens = @oauth2_client.check_tokens(
        **options.slice(:access_token, :refresh_token), token_type: @token_type
      )

      CONNECTION.headers['Client-ID'] = client_id

      renew_authorization_header if access_token
    end

    %i[access_token refresh_token].each do |key|
      define_method(key) { tokens[key] }
    end

    def create_clip(options = {})
      require_access_token do
        initialize_response Clip, post('clips', options)
      end
    end

    def create_entitlement_grant_url(options = {})
      require_access_token do
        initialize_response EntitlementGrantUrl, post('entitlements/upload', options)
      end
    end

    def get_clips(options = {})
      initialize_response Clip, get('clips', options)
    end

    def get_bits_leaderboard(options = {})
      require_access_token do
        initialize_response BitsLeader, get('bits/leaderboard', options)
      end
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

    private

    def initialize_response(data_class, http_response)
      Response.new(data_class, http_response: http_response)
    end

    %w[get post put].each do |http_method|
      define_method http_method do |resource, params|
        http_response = CONNECTION.public_send http_method, resource, params

        raise APIError.new(http_response.status, http_response.body) unless http_response.success?

        http_response
      end
    end

    def renew_authorization_header
      CONNECTION.headers['Authorization'] = "Bearer #{access_token}"
    end

    def request(http_method, *args)
      Retriable.with_context(:twitch) do
        CONNECTION.public_send http_method, *args
      end
    end

    def require_access_token
      response = yield
      if response.success? ||
          @token_type != :user ||
          response.status != 401 ||
          ## Here can be another error, like "missing required oauth scope"
          response.body[:message] != 'invalid oauth token'
        return response
      end

      @tokens = @oauth2_client.refreshed_tokens(refresh_token: refresh_token)
      renew_authorization_header
      yield
    end
  end
end
