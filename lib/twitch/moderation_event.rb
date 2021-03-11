# frozen_string_literal: true

module Twitch
  # Information about a moderation action.
  # The action is determined based on the `event_type` field.
  class ModerationEvent
    # Fields to be converted from ISO 8601 string to a typed date.
    DATE_ATTRIBUTES = %i[event_timestamp].freeze

    # ID of the moderation event.
    attr_reader :id
    # Event type.
    # The `moderation.user` prefix is for user bans and unbans in a channel.
    # The `moderation.moderator` prefix is for addition and removal of moderators in a channel.
    attr_reader :event_type
    # Time at which the event happened.
    attr_reader :event_timestamp
    # Version of the endpoint the data was retrieved from.
    attr_reader :version
    # A hash containing information about the moderation action.
    attr_reader :event_data

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
