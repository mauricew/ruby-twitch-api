# frozen_string_literal: true

module Twitch
  class Client
    # API methods for extensions
    module Extensions
      def get_user_extensions(options = {})
        initialize_response Extension, get('users/extensions/list', options)
      end

      def get_user_active_extensions(options = {})
        initialize_response ExtensionsByTypes, get('users/extensions', options)
      end

      def update_user_extensions(options = {})
        initialize_response ExtensionsByTypes, put('users/extensions', options)
      end
    end
  end
end
