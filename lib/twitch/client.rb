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
      if client_id.nil? && access_token.nil?
        raise 'An identifier token (client ID or bearer token) is required'
      end

      warn TOKENS_CONFLICT_WARNING if client_id && access_token

      CONNECTION.headers['Client-ID'] = client_id unless client_id.nil?

      unless access_token.nil?
        access_token = access_token.gsub(/^Bearer /, '')
        CONNECTION.headers['Authorization'] = "Bearer #{access_token}"
      end

      @with_raw = with_raw
    end

    def create_clip(options = {})
      Response.new(Clip, post('clips', options))
    end

    def create_entitlement_grant_url(options = {})
      Response.new(EntitlementGrantUrl, post('entitlements/upload', options))
    end

    def create_stream_marker(options = {})
      Response.new(StreamMarker, post('streams/markers', options))
    end

    def get_clips(options = {})
      Response.new(Clip, get('clips', options))
    end

    def get_bits_leaderboard(options = {})
      Response.new(BitsLeader, get('bits/leaderboard', options))
    end

    def get_games(options = {})
      Response.new(Game, get('games', options))
    end

    def get_top_games(options = {})
      Response.new(Game, get('games/top', options))
    end

    def get_game_analytics(options = {})
      Response.new(GameAnalytic, get('analytics/games', options))
    end

    def get_stream_markers(options = {})
      Response.new(StreamMarkerResponse, get('streams/markers', options))
    end

    def get_streams(options = {})
      Response.new(Stream, get('streams', options))
    end

    def get_streams_metadata(options = {})
      Response.new(StreamMetadata, get('streams/metadata', options))
    end

    def get_users_follows(options = {})
      Response.new(UserFollow, get('users/follows', options))
    end

    def get_users(options = {})
      Response.new(User, get('users', options))
    end

    def update_user(options = {})
      Response.new(User, put('users', options))
    end

    def get_videos(options = {})
      Response.new(Video, get('videos', options))
    end

    private

    def get(resource, params)
      http_res = CONNECTION.get(resource, params)
      finish(http_res)
    end

    def post(resource, params)
      http_res = CONNECTION.post(resource, params)
      finish(http_res)
    end

    def put(resource, params)
      http_res = CONNECTION.put(resource, params)
      finish(http_res)
    end

    def finish(http_res)
      raise ApiError.new(http_res.status, http_res.body) unless http_res.success?

      {
        http_res: http_res,
        with_raw: @with_raw
      }
    end
  end
end
