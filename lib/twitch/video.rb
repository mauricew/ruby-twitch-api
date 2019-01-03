require "time"

module Twitch
  # A captured broadcast or portion of a broadcast.
  class Video
    DATE_ATTRIBUTES = [:created_at, :published_at]

    # ID of the video.
    attr_reader :id
    # Title of the video.
    attr_reader :title
    # Description of the video.
    attr_reader :description
    # Language of the video.
    attr_reader :language
    # Number of views 
    attr_reader :view_count
    # Date the video was created.
    attr_reader :created_at
    # Date the video was published.
    attr_reader :published_at
    # URL to the thumbnail image of the video.
    attr_reader :thumbnail_url
    # Type of the video (archive, highlight or upload).
    attr_reader :type
    # URL of the video.
    attr_reader :url
    # ID of the user who uploaded/broadcasted the video.
    attr_reader :user_id
    # Display name of the user who uploaded/broadcasted the video.
    attr_reader :user_name
    # Viewability of the video (public or private)
    attr_reader :viewable
    # Duration of the video, in the format
    # 0h0m0s
    attr_reader :duration

    def initialize(attributes = {})
      attributes.each do |k, v|
        if DATE_ATTRIBUTES.include?(k.to_sym)
          instance_variable_set("@#{k}", Time.parse(v))
        else
          instance_variable_set("@#{k}", v)
        end
      end
    end
    
  end
end
