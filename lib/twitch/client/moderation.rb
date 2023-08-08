# frozen_string_literal: true

module Twitch
  class Client
    # API methods for stream moderation
    module Moderation
      def check_automod_status(options = {})
        initialize_response AutomodMessageStatus, post('moderation/enforcements/status', options)
      end

      def get_banned_events(options = {})
        initialize_response ModerationEvent, get('moderation/banned/events', options)
      end

      def get_banned_users(options = {})
        initialize_response UserBan, get('moderation/banned', options)
      end

      def get_moderators(options = {})
        initialize_response Moderator, get('moderation/moderators', options)
      end

      def get_moderator_events(options = {})
        initialize_response ModerationEvent, get('moderation/moderators/events', options)
      end
    end
  end
end
