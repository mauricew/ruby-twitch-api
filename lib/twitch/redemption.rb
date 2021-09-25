# frozen_string_literal: true

module Twitch
  # Data object for Twitch users
  class Redemption
    # ID of the broadcaster.
    attr_reader :broadcaster_id
    # Unformatted (lowercase) username of thebroadcaster.
    attr_reader :broadcaster_login
    # Formatted username of the broadcaster.
    attr_reader :broadcaster_display_name
    # ID of the redemption.
    attr_reader :id
    # ID of the user.
    attr_reader :user_id
    # Unformatted (lowercase) username of the user.
    attr_reader :user_login
    # Formatted username of the user.
    attr_reader :user_name
    # The associated reward being redeemed
    attr_reader :reward
    # The user input (e.g. text) if allowed by the reward
    attr_reader  :user_input,
    # The status of the redemption's fulfillment
    attr_reader :status
    # The timestamp of the redemption
    attr_reader :redeemed_at

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
