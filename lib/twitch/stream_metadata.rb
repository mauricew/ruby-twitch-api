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
      @user_id = attributes['user_id']
      @user_name = attributes['user_name']
      @game_id = attributes['game_id']

      # Since more games can be supported in the future,
      # this will ensure they will all be available.
      attributes.each do |k, v|
        unless instance_variables.include?("@#{k}".to_sym)
          self.class.send(:attr_reader, k.to_sym)
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end