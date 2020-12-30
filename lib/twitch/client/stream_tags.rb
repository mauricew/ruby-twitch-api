# frozen_string_literal: true

module Twitch
  class Client
    ## API methods for stream tags
    module StreamTags
      def get_all_stream_tags(options = {})
        initialize_response StreamTag, get('tags/streams', options)
      end

      def get_stream_tags(options = {})
        require_access_token do
          initialize_response StreamTag, get('streams/tags', options)
        end
      end

      # This method returns 204 No Content, so @data will be nil.
      def replace_stream_tags(options = {})
        require_access_token do
          initialize_response nil, put('streams/tags', options)
        end
      end
    end
  end
end
