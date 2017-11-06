require "faraday"
require "faraday_middleware"

require "twitch/stream"
require "twitch/user"

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

    def get_streams(options = {})
      res = get('streams', options)

      streams = res.body['data'].map { |s| Stream.new(s) }
    end

    def get_users(options = {})
      res = get('users', options)

      users = res.body['data'].map { |u| User.new(u) }
    end

    private

      def get(resource, params)
        res = @conn.get(resource, params)

        unless res.status == 200
          msg= %Q{The server returned an error.
#{res.body["error"]}: #{res.body["message"]}
Status: #{res.body["status"]}}

          raise Exception.new(msg)
        end

        res
      end
  end
end
