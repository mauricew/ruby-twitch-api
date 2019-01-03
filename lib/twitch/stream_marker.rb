module Twitch
  # A point of time in a stream VOD that was marked while it is live.
  class StreamMarker
    # ID of the stream marker.
    attr_reader :id
    # Date at which the stream marker was created.
    attr_reader :created_at
    # Description of the stream marker.
    attr_reader :description
    # Elapsed time in the VOD in seconds at which the stream marker was created.
    attr_reader :position_seconds
    # URL pointing to the video and timestamp of the stream marker.
    # Not returned upon creation.
    attr_reader :url

    def initialize(attributes = {})
      @id = attributes['id']
      @created_at = Time.parse(attributes['created_at'])
      @description = attributes['description']
      @position_seconds = attributes['position_seconds']
      @url = attributes['URL']
    end
  end

  # The response envelope for the "Get Stream Markers" endpoint.
  class StreamMarkerResponse
    attr_reader :user_id
    attr_reader :user_name
    attr_reader :videos

    def initialize(attributes = {})
      @user_id = attributes['user_id']
      @user_name = attributes['user_name']
      @videos = attributes['videos'].map { |v| VideoStreamMarkers.new(v) }
    end
  end

  # A video with a list of markers.
  class VideoStreamMarkers
    attr_reader :video_id
    attr_reader :markers

    def initialize(attributes = {})
      @video_id = attributes['video_id']
      @markers = attributes['markers'].map{ |m| StreamMarker.new(m) }
    end
  end
end
