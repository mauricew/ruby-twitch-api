require "time"

module Twitch
  # A user's broadcasting session.
  class Stream
    # Fields to be converted from ISO 8601 string to a typed date.
    DATE_ATTRIBUTES = [:started_at]

    # ID of the stream.
    attr_reader :id
    # ID of the user broadcasting.
    attr_reader :user_id
    # Username of the user broadcasting.
    attr_reader :user_name
    # ID of the game being broadcast.
    attr_reader :game_id
    # Associated community IDs for the broadcaster.
    attr_reader :community_ids
    # The type of broadcast
    # which may include 'live', 'playlist', or 'watch_party'.
    attr_reader :type
    # Title of the stream session.
    attr_reader :title
    # Concurrent viewer count of the broadcast.
    attr_reader :viewer_count
    # Date at which the broadcast started.
    attr_reader :started_at
    # Language of the broadcast.
    attr_reader :language
    # URL of the latest thumbnail image for the broadcast.
    attr_reader :thumbnail_url


    def initialize(attributes = {})
      attributes.each do |k, v|
        if DATE_ATTRIBUTES.include?(k.to_sym)
          instance_variable_set("@#{k}", Time.parse(v))
        else
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end
