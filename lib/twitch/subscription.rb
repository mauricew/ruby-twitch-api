# frozen_string_literal: true

module Twitch
  # A user's voluntary contribution to a streamer
  class Subscription
    # ID of the user being subscribed to.
    attr_reader :broadcaster_id
    # Username of the user being subscribed to.
    attr_reader :broadcaster_name
    # Whether the subscription was received as a gift.
    attr_reader :is_gift
    # Tier of the subscription.
    # 1000 = Tier 1, 2000 = Tier 2, 3000 = Tier 3
    attr_reader :tier
    # Descriptive name of the subscription.
    attr_reader :plan_name
    # ID of the subscribing user.
    attr_reader :user_id
    # Username of the subscribing user.
    attr_reader :user_name

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
