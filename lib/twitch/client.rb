# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

require_relative 'response'
require_relative 'api_error'
require_relative 'bits_leader'
require_relative 'clip'
require_relative 'entitlement_grant_url'
require_relative 'game'
require_relative 'game_analytic'
require_relative 'stream'
require_relative 'stream_marker'
require_relative 'stream_metadata'
require_relative 'user'
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

    TOKENS_CONFLICT_WARNING = <<~TEXT
      WARNING:
      It is recommended that only one identifier token is specified.
      Unpredictable behavior may follow.
    TEXT

    private_constant :TOKENS_CONFLICT_WARNING

    # Initializes a Twitch client.
    #
    # - client_id [String] The client ID.
    # Used as the Client-ID header in a request.
    # - access_token [String] An access token.
    # Used as the Authorization header in a request.
    # Any "Bearer " prefix will be stripped.
    # - with_raw [Boolean] Whether to include raw HTTP response
    # Intended for testing/checking API results
    def initialize(client_id: nil, access_token: nil, with_raw: false)
      unless client_id || access_token
        raise 'An identifier token (client ID or bearer token) is required'
      end

      warn TOKENS_CONFLICT_WARNING if client_id && access_token

      CONNECTION.headers['Client-ID'] = client_id if client_id

      if access_token
        access_token = access_token.gsub(/^Bearer /, '')
        CONNECTION.headers['Authorization'] = "Bearer #{access_token}"
      end

      @with_raw = with_raw
    end

    def create_clip(options = {})
      initialize_response Clip, post('clips', options)
    end

    def create_entitlement_grant_url(options = {})
      initialize_response EntitlementGrantUrl, post('entitlements/upload', options)
    end

    def create_stream_marker(options = {})
      initialize_response StreamMarker, post('streams/markers', options)
    end

    def get_clips(options = {})
      initialize_response Clip, get('clips', options)
    end

    def get_bits_leaderboard(options = {})
      initialize_response BitsLeader, get('bits/leaderboard', options)
    end

    def get_games(options = {})
      initialize_response Game, get('games', options)
    end

    def get_top_games(options = {})
      initialize_response Game, get('games/top', options)
    end

    def get_game_analytics(options = {})
      initialize_response GameAnalytic, get('analytics/games', options)
    end

    def get_stream_markers(options = {})
      initialize_response StreamMarkerResponse, get('streams/markers', options)
    end

    def get_streams(options = {})
      initialize_response Stream, get('streams', options)
    end

    def get_streams_metadata(options = {})
      initialize_response StreamMetadata, get('streams/metadata', options)
    end

    def get_users_follows(options = {})
      initialize_response UserFollow, get('users/follows', options)
    end

    def get_users(options = {})
      initialize_response User, get('users', options)
    end

    def update_user(options = {})
      initialize_response User, put('users', options)
    end

    def get_videos(options = {})
      initialize_response Video, get('videos', options)
    end

    def search(options = {})
      initialize_response User, get('search/channels', options)
    end

    private

    def initialize_response(data_class, http_response)
      Response.new(data_class, http_response: http_response, with_raw: @with_raw)
    end

    %w[get post put].each do |http_method|
      define_method http_method do |resource, params|
        http_response = CONNECTION.public_send http_method, resource, params

        raise APIError.new(http_response.status, http_response.body) unless http_response.success?

        http_response
      end
    end
  end
end
