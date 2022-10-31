# frozen_string_literal: true

module Twitch
  # Data object for Twitch channels
  # https://dev.twitch.tv/docs/api/reference#get-channel-information
  class Channel
    # Twitch User ID of this channel owner.
    attr_reader :broadcaster_id
    # Broadcaster's user login name.
    attr_reader :broadcaster_login
    # Twitch user display name of this channel owner.
    attr_reader :broadcaster_name
    # Language of the channel.
    # A language value is either the ISO 639-1 two-letter code for a supported stream language
    # or "other".
    attr_reader :broadcaster_language
    # Current game ID being played on the channel .
    attr_reader :game_id
    # Name of the game being played on the channel.
    attr_reader :game_name
    # Title of the stream.
    attr_reader :title
    # Stream delay in seconds.
    attr_reader :delay

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
