# frozen_string_literal: true

module Twitch
  # Represents a webhook event notification from Twitch
  class WebhookEvent
    # The subscription information
    attr_reader :subscription
    # The event data
    attr_reader :event
    # The timestamp of when the notification was sent
    attr_reader :timestamp

    def initialize(attributes = {})
      @subscription = attributes['subscription']
      @event = attributes['event']
      @timestamp = Time.parse(attributes['timestamp']) if attributes['timestamp']
    end

    # The type of the event (e.g., "channel.follow")
    def type
      subscription['type']
    end

    # The version of the subscription
    def version
      subscription['version']
    end

    # The status of the subscription
    def status
      subscription['status']
    end

    # The condition parameters for this subscription
    def condition
      subscription['condition']
    end

    # Whether this is a revocation event
    def revoked?
      status == 'revoked'
    end
  end
end
