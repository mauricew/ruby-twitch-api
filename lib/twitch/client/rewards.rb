# frozen_string_literal: true

module Twitch
  class Client
    ## API method for rewards
    module Rewards
      def create_custom_reward(options = {})
        require_access_token do
          initialize_response Reward, post('channel_points/custom_rewards', options)
        end
      end

      def get_custom_reward(options = {})
        require_access_token do
          initialize_response Reward, get('channel_points/custom_rewards', options)
        end
      end

      def delete_custom_reward(options = {})
        require_access_token do
          initialize_response Reward, delete('channel_points/custom_rewards', options)
        end
      end

      def get_custom_reward_redemption(options = {})
        require_access_token do
          initialize_response Reward, get('channel_points/custom_rewards/redemptions', options)
        end
      end

      def update_custom_reward(options = {})
        require_access_token do
          initialize_response Reward, patch('channel_points/custom_rewards', options)
        end
      end

      def update_redemption_status(options = {})
        require_access_token do
          initialize_response Reward, patch('channel_points/custom_rewards/redemptions', options)
        end
      end
    end
  end
end
