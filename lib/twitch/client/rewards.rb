# frozen_string_literal: true

module Twitch
  class Client
    ## API method for rewards
    module Rewards
      def create_custom_reward(options = {})
        initialize_response Reward, post('channel_points/custom_rewards', options)
      end

      def get_custom_reward(options = {})
        initialize_response Reward, get('channel_points/custom_rewards', options)
      end

      def delete_custom_reward(options = {})
        initialize_response Reward, delete('channel_points/custom_rewards', options)
      end

      def get_custom_reward_redemption(options = {})
        initialize_response Reward, get('channel_points/custom_rewards/redemptions', options)
      end

      def update_custom_reward(options = {})
        initialize_response Reward, patch('channel_points/custom_rewards', options)
      end

      def update_redemption_status(options = {})
        initialize_response Reward, patch('channel_points/custom_rewards/redemptions', options)
      end
    end
  end
end
