require "faraday"
require "faraday_middleware"

require "twitch/response"
require "twitch/api_error"
require "twitch/stream"
require "twitch/stream_metadata"
require "twitch/user_follow"
require "twitch/game"
require "twitch/video"

module Twitch
  class Client
    API_ENDPOINT = "https://api.twitch.tv/helix".freeze

    def initialize(client_id:, access_token: nil)
      headers = {
        "Client-ID": client_id,
        "User-Agent": "twitch-api ruby client #{Twitch::VERSION}"
      }
      unless access_token.nil?
        headers["Authorization"] = "Bearer #{access_token}"
      end
      
      @conn = Faraday.new(API_ENDPOINT, { headers: headers }) do |faraday|
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end


    def get_games(options = {})
      res = get('games', options)

      games = res[:data].map { |g| Game.new(g) }
      Response.new(games, res[:rate_limit_headers])
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

    def get_videos(options = {})
      res = get('videos', options)

      videos = res[:data].map { |v| Video.new(v) }
      Response.new(videos, res[:rate_limit_headers], res[:pagination])
    end

    private

      def get(resource, params)
        http_res = @conn.get(resource, params)

        unless http_res.success?
          raise ApiError.new(http_res.status, http_res.body)
        end

        rate_limit_headers = Hash[http_res.headers.select { |k,v|
          k.to_s.downcase.match(/^ratelimit/)
        }.map { |k,v| [k.gsub('ratelimit-', '').to_sym, v] }]

        pagination = http_res.body['pagination'] if http_res.body.key?('pagination')

        { 
          data: http_res.body['data'],
          pagination: pagination,
          rate_limit_headers: rate_limit_headers
        }
      end
  end
end
