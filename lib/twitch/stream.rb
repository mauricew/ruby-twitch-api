# frozen_string_literal: true

require 'time'

module Twitch
  # A user's broadcasting session.
  class Stream
    # ID of the stream.
    attr_reader :id
    # ID of the user broadcasting.
    attr_reader :user_id
    # Username of the user broadcasting.
    attr_reader :user_name
    # ID of the game being broadcast.
    attr_reader :game_id
    # Name of the game being broadcast.
    attr_reader :game_name
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
    # Ids of tags on the live stream
    attr_reader :tag_ids

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set :"@#{key}", value
      end
    end
  end
end
