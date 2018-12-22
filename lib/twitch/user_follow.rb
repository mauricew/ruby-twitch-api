module Twitch
  # Represents a relationship of one user following another.
  class UserFollow
    # User ID of the *following* user.
    attr_reader :from_id
    # Display name of the *following* user.
    attr_reader :from_name
    # User ID of the *followed* user.
    attr_reader :to_id
    # User name of the *followed* user.
    attr_reader :to_name
    # Date at which the follow action was performed.
    attr_reader :followed_at

    def initialize(attributes = {})
      @from_id = attributes['from_id']
      @from_name = attributes['from_name']
      @to_id = attributes['to_id']
      @to_name = attributes['to_name']
      @followed_at = Time.iso8601(attributes['followed_at'])
    end
  end
end