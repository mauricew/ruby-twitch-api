# frozen_string_literal: true

module Twitch
  class Client
    ## API method for streams
    module Streams
      def create_stream_marker(options = {})
        initialize_response StreamMarker, post('streams/markers', options)
      end

      def get_stream_markers(options = {})
        initialize_response StreamMarkerResponse, get('streams/markers', options)
      end

      def get_streams(options = {})
        initialize_response Stream, get('streams', options)
      end

      ## TODO: Can't find this method in documentation, test it
      def get_streams_metadata(options = {})
        initialize_response StreamMetadata, get('streams/metadata', options)
      end

      def get_stream_key(options = {})
        initialize_response nil, get('streams/key', options)
      end
    end
  end
end
