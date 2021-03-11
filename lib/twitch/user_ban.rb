# frozen_string_literal: true

module Twitch
  # Ban information for a user.
  class UserBan
    # Fields to be converted from ISO 8601 string to a typed date.
    DATE_ATTRIBUTES = %i[expires_at].freeze

    # ID of the banned/timed-out user.
    attr_reader :user_id
    # Username of the banned/timed-out user.
    attr_reader :user_name
    # Date of when the time-out will expire (nil for permanent bans)
    attr_reader :expires_at

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
