module Twitch
  # Represents a relationship of one user following another.
  class UserFollow
    # User ID of the *following* user.
    attr_reader :from_id
    # User ID of the *followed* user.
    attr_reader :to_id
    # Date at which the follow action was performed.
    attr_reader :followed_at

    def initialize(attributes = {})
      @from_id = attributes['from_id']
      @to_id = attributes['to_id']
      @followed_at = Time.iso8601(attributes['followed_at'])
    end
  end
end