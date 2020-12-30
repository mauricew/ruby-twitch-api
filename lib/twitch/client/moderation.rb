module Twitch
  class Client
    # API methods for stream moderation
    module Moderation
      def check_automod_status(options = {})
        require_access_token do
          initialize_response AutomodMessageStatus, post('moderation/enforcements/status', options)
        end
      end

      def get_banned_events(options = {})
        require_access_token do
          initialize_response ModerationEvent, get('moderation/banned/events', options)
        end
      end

      def get_banned_users(options = {})
        require_access_token do
          initialize_response UserBan, get('moderation/banned', options)
        end
      end

      def get_moderators(options = {})
        require_access_token do
          initialize_response Moderator, get('moderation/moderators', options)
        end
      end

      def get_moderator_events(options = {})
        require_access_token do
          initialize_response ModerationEvent, get('moderation/moderators/events', options)
        end
      end
    end
  end
end