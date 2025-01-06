# frozen_string_literal: true

module Twitch
  class Client
    # Module for EventSub webhook functionality
    module Webhooks
      # Create a new webhook subscription
      # @param type [String] The subscription type (e.g., "channel.follow")
      # @param version [String] The version of the subscription type
      # @param condition [Hash] Subscription-specific parameters
      # @param callback_url [String] URL where notifications will be sent
      # @param secret [String] Secret used to verify webhook signatures
      # @return [Twitch::Response] Response containing subscription details
      def create_webhook_subscription(type:, condition:, callback_url:, secret:, version: 1)
        initialize_response nil, post('eventsub/subscriptions', {
          type: type,
          version: version,
          condition: condition,
          transport: {
            method: 'webhook',
            callback: callback_url,
            secret: secret
          }
        })
      end

      # Get list of webhook subscriptions
      # @param status [String, nil] Filter by subscription status
      # @param type [String, nil] Filter by subscription type
      # @return [Twitch::Response] Response containing list of subscriptions
      def get_webhook_subscriptions(status: nil, type: nil)
        params = {}
        params[:status] = status if status
        params[:type] = type if type

        initialize_response nil, get('eventsub/subscriptions', params)
      end

      # Delete a webhook subscription
      # @param id [String] ID of the subscription to delete
      # @return [Twitch::Response] Empty response if successful
      def delete_webhook_subscription(id:)
        initialize_response nil, delete('eventsub/subscriptions', { id: id })
      end
    end

    include Webhooks
  end
end
