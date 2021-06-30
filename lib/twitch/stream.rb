# frozen_string_literal: true

require 'time'

module Twitch
  # A user's broadcasting session.
  class Stream
    # Fields to be converted from ISO 8601 string to a typed date.
    DATE_ATTRIBUTES = %i[started_at].freeze

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
        if DATE_ATTRIBUTES.include?(key.to_sym)
          instance_variable_set "@#{key}", Time.parse(value)
        else
          instance_variable_set "@#{key}", value
        end
      end
    end
  end
end
