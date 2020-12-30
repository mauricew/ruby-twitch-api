# frozen_string_literal: true

module Twitch
  # A compiled response from the API.
  class Response
    extend Forwardable
    def_delegators :@http_response, :body, :success?

    # The requested data.
    attr_reader :data
    # A total amount of entities.
    # Applies to select endpoints.
    attr_reader :total
    # A range of dates in which data is effective.
    # Usually contains the keys start_date and end_date.
    # Applies to select endpoints.
    attr_reader :date_range
    # A hash containing a pagination token.
    # Access it with
    #    pagination['cursor']
    # Applies to select endpoints.
    attr_reader :pagination
    # The total amount of calls that can be used in
    # the rate limit period (one minute by default).
    attr_reader :rate_limit
    # The remaining amount of calls for the rate limit period.
    attr_reader :rate_limit_remaining
    # The date at which the rate limit is reset.
    attr_reader :rate_limit_resets_at
    # The total amount of clips that can be created in
    # the clip rate limit period (currently unknown).
    attr_reader :clip_rate_limit
    # The remaining amount of clips that can be created in
    # the clip rate limit period.
    attr_reader :clip_rate_limit_remaining
    # The HTTP raw response
    attr_reader :raw

    def initialize(data_class, http_response:)
      @http_response = http_response
      @raw = @http_response

      if data_class
        @data = body['data'].map { |data_element| data_class.new(data_element) }
      end

      parse_rate_limits

      @pagination = body['pagination']
      @total = body['total']
      @date_range = body['date_range']
    end

    private

    def parse_rate_limits
      @rate_limit = rate_limit_headers[:limit].to_i
      @rate_limit_remaining = rate_limit_headers[:remaining].to_i
      @rate_limit_resets_at = Time.at(rate_limit_headers[:reset].to_i)

      @clip_rate_limit = rate_limit_headers[:'helixclipscreation-limit']
      @clip_rate_limit_remaining = rate_limit_headers[:'helixclipscreation-remaining']
    end

    def rate_limit_headers
      @rate_limit_headers ||=
        @http_response.headers
          .select { |key, _value| key.to_s.downcase.match(/^ratelimit/) }
          .transform_keys { |key| key.gsub('ratelimit-', '').to_sym }
    end
  end
end
