# frozen_string_literal: true

module Twitch
  class Client
    ## API method for games
    module Games
      def get_games(options = {})
        initialize_response Game, get('games', options)
      end

      def get_top_games(options = {})
        initialize_response Game, get('games/top', options)
      end

      def get_game_analytics(options = {})
        require_access_token do
          initialize_response GameAnalytic, get('analytics/games', options)
        end
      end
    end
  end
end
