module Twitch
  class UserFollow
    attr_reader :from_id, :to_id, :followed_at

    def initialize(attributes = {})
      @from_id = attributes['from_id']
      @to_id = attributes['to_id']
      @followed_at = Time.iso8601(attributes['followed_at'])
    end
  end
end