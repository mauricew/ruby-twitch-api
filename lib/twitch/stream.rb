module Twitch
  class Stream
    attr_reader :id, :user_id, :game_id, :community_ids, :type, :title, :viewer_count, :started_at, :language, :thumbnail_url
    
    def initialize(attributes = {})
      attributes.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end