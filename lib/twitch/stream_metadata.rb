# frozen_string_literal: true

module Twitch
  # A set of metadata to provide additional information about a
  # game being streamed.
  # Additional getters are assigned at initialization time, e.g.
  #    self.hearthstone
  # has data when Hearthstone is being streamed.
  # Other games may be included, but will be set to nil
  # if they aren't the game currently being streamed.
  class StreamMetadata
    # ID of the streaming user.
    attr_reader :user_id
    # Display name of the streaming user.
    attr_reader :user_name
    # ID of the game being playead.
    attr_reader :game_id

    def initialize(attributes = {})
      @attributes = attributes

      @user_id = @attributes['user_id']
      @user_name = @attributes['user_name']
      @game_id = @attributes['game_id']
    end

    # Since more games can be supported in the future,
    # this will ensure they will all be available.
    def method_missing(name, *args)
      name = name.to_s

      return super unless @attributes.key?(name)

      @attributes[name]
    end

    def respond_to_missing?(name)
      name = name.to_s

      @attributes.key?(name) ? true : super
    end
  end
end
