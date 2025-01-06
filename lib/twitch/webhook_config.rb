# frozen_string_literal: true

module Twitch
  # Configuration class for Twitch webhooks
  class WebhookConfig
    class << self
      attr_accessor :secret, :callback_url, :client, :logger

      def configure
        yield self
      end

      def setup_handlers(&on_setup)
        # Allow application to do any necessary setup before registering handlers
        on_setup&.call

        # Setup handlers with client
        WebhookHandler.setup_client(client)
      end

      def log(message)
        return unless logger

        logger.info(message)
      end

      def log_error(message)
        return unless logger

        logger.error(message)
      end
    end
  end
end
