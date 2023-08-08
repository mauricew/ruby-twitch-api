# frozen_string_literal: true

module Twitch
  # Data object for Twitch users
  class CustomReward
    # ID of the broadcaster.
    attr_reader :broadcaster_id
    # Unformatted (lowercase) username of thebroadcaster.
    attr_reader :broadcaster_login
    # Formatted username of the broadcaster.
    attr_reader :broadcaster_display_name
    # ID of the reward
    attr_reader :id
    # Title of the reward
    attr_reader :title

    attr_reader :prompt, :cost, :image, :default_image, :is_enabled, :is_user_input_required,
    :max_per_stream_setting, :max_per_user_setting, :global_cooldown_setting, :is_paused,
    :is_in_stock, :should_redemptions_skip_request_queue, :redemptions_redeemed_current_stream,
    :cooldown_expires_at

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
