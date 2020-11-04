# frozen_string_literal: true

module Twitch
  class Client
    ## API method for streams
    module Streams
      def create_stream_marker(options = {})
        require_access_token do
          initialize_response StreamMarker, post('streams/markers', options)
        end
      end

      def get_stream_markers(options = {})
        require_access_token do
          initialize_response StreamMarkerResponse, get('streams/markers', options)
        end
      end

      def get_streams(options = {})
        initialize_response Stream, get('streams', options)
      end

      ## TODO: Can't find this method in documentation, test it
      def get_streams_metadata(options = {})
        initialize_response StreamMetadata, get('streams/metadata', options)
      end
    end
  end
end
