module Twitch
  class Client
    # API methods for subscriptions
    module Subscriptions
      def get_broadcaster_subscription(options = {})
        require_access_token do
          initialize_response Subscription, post('subscriptions', options)
        end
      end
    end
  end
end