require "faraday"
require "faraday_middleware"

require "twitch/response"
require "twitch/api_error"
require "twitch/bits_leader"
require "twitch/clip"
require "twitch/entitlement_grant_url"
require "twitch/game"
require "twitch/game_analytic"
require "twitch/stream"
require "twitch/stream_metadata"
require "twitch/user"
require "twitch/user_follow"
require "twitch/video"

module Twitch
  class Client
    # Helix API endpoint.
    API_ENDPOINT = "https://api.twitch.tv/helix".freeze

    # Initializes a Twitch client.
    # 
    # - client_id [String] The client ID.
    # Used as the Client-ID header in a request.
    # - access_token [String] An access token.
    # Used as the Authorization header in a request.
    # Any "Bearer " prefix will be stripped.
    def initialize(client_id: nil, access_token: nil)
      if client_id.nil? && access_token.nil?
        raise "An identifier token (client ID or bearer token) is required"
      elsif !!client_id && !!access_token
        warn(%{WARNING:
It is recommended that only one identifier token is specified.
Unpredictable behavior may follow.})
      end

      headers = {
        "User-Agent": "twitch-api ruby client #{Twitch::VERSION}"
      }
      unless client_id.nil?
        headers["Client-ID"] = client_id
      end
      unless access_token.nil?
        access_token = access_token.gsub(/^Bearer /, "")
        headers["Authorization"] = "Bearer #{access_token}"
      end
      
      @conn = Faraday.new(API_ENDPOINT, { headers: headers }) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def create_clip(options = {})
      res = post('clips', options)

      clip = res[:data].map { |c| Clip.new(c) }
      Response.new(clip, res[:rate_limit_headers])
    end

    def create_entitlement_grant_url(options = {})
      res = post('entitlements/upload', options)

      entitlement_grant = res[:data].map { |e| EntitlementGrantUrl.new(e) }
      Response.new(entitlement_grant, res[:rate_limit_headers])
    end

    def get_clips(options = {})
      res = get('clips', options)

      clips = res[:data].map { |c| Clip.new(c) }
      Response.new(clips, res[:rate_limit_headers])
    end

    def get_bits_leaderboard(options = {})
      res = get('bits/leaderboard', options)

      bits_leaders = res[:data].map { |bl| BitsLeader.new(bl) }
      Response.new(
        bits_leaders, 
        res[:rate_limit_headers],
        nil,
        res[:full_body]['total'], 
        res[:full_body]['date_range']
      )
    end

    def get_games(options = {})
      res = get('games', options)

      games = res[:data].map { |g| Game.new(g) }
      Response.new(games, res[:rate_limit_headers])
    end

    def get_top_games(options = {})
      res = get('games/top', options)

      games = res[:data].map { |g| Game.new(g) }
      Response.new(games, res[:rate_limit_headers], res[:pagination])
    end

    def get_game_analytics
      res = get('analytics/games'. options)

      game_analytics = res[:data].map { |ga| GameAnalytic.new(ga) }
      Response.new(game_analytics, res[:rate_limit_headers])
    end

    def get_streams(options = {})
      res = get('streams', options)

      streams = res[:data].map { |s| Stream.new(s) }
      Response.new(streams, res[:rate_limit_headers], res[:pagination])
    end

    def get_streams_metadata(options = {})
      res = get('streams/metadata', options)

      stream_metadata = res[:data].map { |s| StreamMetadata.new(s) }
      Response.new(stream_metadata, res[:rate_limit_headers], res[:pagination])
    end

    def get_users_follows(options = {})
      res = get('users/follows', options)

      users = res[:data].map { |u| UserFollow.new(u) }
      Response.new(users, res[:rate_limit_headers], res[:pagination])
    end

    def get_users(options = {})
      res = get('users', options)

      users = res[:data].map { |u| User.new(u) }
      Response.new(users, res[:rate_limit_headers])
    end

    def update_user(options = {})
      res = put('users', options)

      user = res[:data].map { |u| User.new(u) }
      Response.new(user, res[:rate_limit_headers])
    end

    def get_videos(options = {})
      res = get('videos', options)

      videos = res[:data].map { |v| Video.new(v) }
      Response.new(videos, res[:rate_limit_headers], res[:pagination])
    end

    private

      def get(resource, params)
        http_res = @conn.get(resource, params)
        finish(http_res)
      end

      def post(resource, params)
        http_res = @conn.post(resource, params)
        finish(http_res)
      end

      def put(resource, params)
        http_res = @conn.put(resource, params)
        finish(http_res)
      end

      def finish(http_res)
        unless http_res.success?
          raise ApiError.new(http_res.status, http_res.body)
        end

        rate_limit_headers = Hash[http_res.headers.select do |k,v|
          k.to_s.downcase.match(/^ratelimit/)
        end.map { |k,v| [k.gsub('ratelimit-', '').to_sym, v] }]

        if http_res.body.key?('pagination')
          pagination = http_res.body['pagination'] 
        end

        # TODO: The return object should only contain one instance of the response body.
        { 
          data: http_res.body['data'],
          full_body: http_res.body,
          pagination: pagination,
          rate_limit_headers: rate_limit_headers
        }
      end
  end
end
