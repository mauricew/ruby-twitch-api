# frozen_string_literal: true

module Twitch
  class Client
    # API methods for subscriptions
    module Subscriptions
      def get_broadcaster_subscription(options = {})
        initialize_response Subscription, post('subscriptions', options)
      end
    end
  end
end
