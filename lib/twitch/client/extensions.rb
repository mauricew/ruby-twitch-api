module Twitch
  class Client
    # API methods for extensions
    module Extensions
      def get_user_extensions(options = {})
        require_access_token do
          initialize_response Extension, get('users/extensions/list', options)
        end
      end

      # TODO This is more of a freeform response, but @data should still be populated
      # This may just be a mapping directly to hash
      def get_user_active_extensions(options = {})
        require_access_token do
          initialize_response nil, get('users/extensions', options)
        end
      end

      # TODO see above method's comment
      def get_user_active_extensions(options = {})
        require_access_token do
          initialize_response nil, put('users/extensions', options)
        end
      end
    end
  end
end
