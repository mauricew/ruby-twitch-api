# frozen_string_literal: true

module Twitch
  # A user who wields some form of power in a broadcaster's Twitch chat.
  # This is simply a user ID/name pair.
  class Moderator
    # User ID of the moderator.
    attr_reader :user_id
    # The user’s login name.
    attr_reader :user_login
    # The user’s display name.
    attr_reader :user_name

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set :"@#{key}", value
      end
    end
  end
end
