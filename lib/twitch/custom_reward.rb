# frozen_string_literal: true

module Twitch
  ## Data object for Twitch custom rewards
  class CustomReward
    ## Data object for images of Twitch custom rewards
    class CustomRewardImage
      # The URL to a small version of the image.
      attr_reader :url_1x
      # The URL to a medium version of the image.
      attr_reader :url_2x
      # The URL to a large version of the image.
      attr_reader :url_4x

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set :"@#{key}", value
        end
      end
    end

    # The ID that uniquely identifies the broadcaster.
    attr_reader :broadcaster_id
    # The broadcaster’s login name.
    attr_reader :broadcaster_login
    # The broadcaster’s display name.
    attr_reader :broadcaster_name
    # The ID that uniquely identifies this custom reward.
    attr_reader :id
    # The title of the reward.
    attr_reader :title
    # The prompt shown to the viewer when they redeem the reward if user input is required
    # (see the `is_user_input_required` field).
    attr_reader :prompt
    # The cost of the reward in Channel Points.
    attr_reader :cost
    # A set of custom images for the reward.
    # This field is `nil` if the broadcaster didn’t upload images.
    attr_reader :image
    # A set of default images for the reward.
    attr_reader :default_image
    # The background color to use for the reward.
    # The color is in Hex format (for example, `#00E5CB`).
    attr_reader :background_color
    # A Boolean value that determines whether the reward is enabled.
    # Is `true` if enabled; otherwise, `false`. Disabled rewards aren’t shown to the user.
    attr_reader :is_enabled
    # A Boolean value that determines whether the user must enter information
    # when redeeming the reward. Is `true` if the user is prompted.
    attr_reader :is_user_input_required
    # The settings used to determine whether to apply a maximum to the number of redemptions
    # allowed per live stream.
    attr_reader :max_per_stream_setting
    # The settings used to determine whether to apply a maximum to the number of redemptions
    # allowed per user per live stream.
    attr_reader :max_per_user_per_stream_setting
    # The settings used to determine whether to apply a cooldown period between redemptions
    # and the length of the cooldown.
    attr_reader :global_cooldown_setting
    # A Boolean value that determines whether the reward is currently paused.
    # Is `true` if the reward is paused. Viewers can’t redeem paused rewards.
    attr_reader :is_paused
    # A Boolean value that determines whether the reward is currently in stock.
    # Is `true` if the reward is in stock. Viewers can’t redeem out of stock rewards.
    attr_reader :is_in_stock
    # A Boolean value that determines whether redemptions should be set to FULFILLED status
    # immediately when a reward is redeemed. If `false`, status is set to UNFULFILLED
    # and follows the normal request queue process.
    attr_reader :should_redemptions_skip_request_queue
    # The number of redemptions redeemed during the current live stream.
    # The number counts against the `max_per_stream_setting` limit.
    # This field is `nil` if the broadcaster’s stream isn’t live
    # or `max_per_stream_setting` isn’t enabled.
    attr_reader :redemptions_redeemed_current_stream
    # The timestamp of when the cooldown period expires.
    # Is `nil` if the reward isn’t in a cooldown state.
    # See the `global_cooldown_setting` field.
    attr_reader :cooldown_expires_at

    IMAGE_ATTRS = %w[image default_image].freeze
    private_constant :IMAGE_ATTRS

    def initialize(attributes = {})
      attributes.each do |key, value|
        value = CustomRewardImage.new(value) if IMAGE_ATTRS.include?(key) && !value.nil?

        instance_variable_set :"@#{key}", value
      end
    end
  end
end
