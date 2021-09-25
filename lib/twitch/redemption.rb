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

    attr_reader :reward, :user_input, :status, :redeemed_at


    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
