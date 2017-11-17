module Twitch
  class StreamMetadata
    attr_reader :user_id, :game_id

    def initialize(attributes = {})
      @user_id = attributes["user_id"].to_i
      @game_id = attributes["game_id"].to_i if attributes["game_id"]

      # Since more games can be supported in the future, this will ensure
      # they will all be available.
      attributes.each do |k, v|
        unless instance_variables.include?("@#{k}".to_sym)
          self.class.send(:attr_reader, k.to_sym)
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end