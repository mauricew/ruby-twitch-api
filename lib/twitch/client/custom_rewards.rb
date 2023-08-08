# frozen_string_literal: true

module Twitch
  class Client
    ## API methods for custom rewards
    module CustomRewards
      def create_custom_reward(options = {})
        initialize_response CustomReward, post('channel_points/custom_rewards', options)
      end

      def get_custom_reward(options = {})
        initialize_response CustomReward, get('channel_points/custom_rewards', options)
      end

      def delete_custom_reward(options = {})
        initialize_response CustomReward, delete('channel_points/custom_rewards', options)
      end

      def get_custom_reward_redemption(options = {})
        initialize_response CustomReward, get('channel_points/custom_rewards/redemptions', options)
      end

      def update_custom_reward(options = {})
        initialize_response CustomReward, patch('channel_points/custom_rewards', options)
      end

      def update_redemption_status(options = {})
        initialize_response(
          CustomReward,
          patch('channel_points/custom_rewards/redemptions', options)
        )
      end
    end
  end
end
