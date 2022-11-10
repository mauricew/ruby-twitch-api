# frozen_string_literal: true

module Twitch
  # A small segment of a broadcast captured by another user.
  class Clip
    # ID of the clip.
    attr_reader :id
    # Title of the clip.
    attr_reader :title
    # Date the clip was created.
    attr_reader :created_at
    # URL of the clip.
    attr_reader :url
    # URL of the thumbnail image.
    attr_reader :thumbnail_url
    # URL for embedding the clip.
    attr_reader :embed_url
    # Number of views.
    attr_reader :view_count
    # Language of the originating broadcast.
    attr_reader :language
    # (User) ID of the clip's source broadcaster.
    attr_reader :broadcaster_id
    # (User) name of the clip's source broadcaster
    attr_reader :broadcaster_name
    # (User) ID of the clip's creator.
    attr_reader :creator_id
    # (User) name of the clip's creator.
    attr_reader :creator_name
    # ID of the game being played.
    attr_reader :game_id
    # ID of the archived broadcast (may not be available).
    attr_reader :video_id

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
