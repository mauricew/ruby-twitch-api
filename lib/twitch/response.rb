module Twitch
  class Response
    attr_reader :data, :pagination,
      :rate_limit, :rate_limit_remaining, :rate_limit_resets_at,
      :clip_rate_limit, :clip_rate_limit_remaining

    def initialize(data, rate_limit_headers, pagination = nil)
      @data = data

      @rate_limit = rate_limit_headers[:limit].to_i
      @rate_limit_remaining = rate_limit_headers[:remaining].to_i
      @rate_limit_resets_at = Time.at(rate_limit_headers[:reset].to_i)

      if rate_limit_headers.keys.any? { |k| k.to_s.start_with?('helixclipscreation') }
        @clip_rate_limit = rate_limit_headers[:'helixclipscreation-limit']
        @clip_rate_limit_remaining = rate_limit_headers[:'helixclipscreation-remaining']
      end

      @pagination = pagination
    end
  end
end