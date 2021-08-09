module Twitch
  class Client
    module EventSubs
      def create_event_sub(options = {})
        initialize_response EventSub, post('eventsub/subscriptions', options)
      end
      def get_event_sub(options = {})
        initialize_response EventSub, get('eventsub/subscriptions', options)
      end
    end
  end
end
