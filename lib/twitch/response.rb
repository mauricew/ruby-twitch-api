module Twitch
  class Response
    attr_reader :data, :pagination,  :rate_limit, :rate_limit_remaining, :rate_limit_resets_at

    def initialize(data, rate_limit_headers, pagination = nil)
      @data = data

      @rate_limit = rate_limit_headers[:limit].to_i
      @rate_limit_remaining = rate_limit_headers[:remaining].to_i
      @rate_limit_resets_at = Time.at(rate_limit_headers[:reset].to_i)

      @pagination = pagination
    end
  end
end