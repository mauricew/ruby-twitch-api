module Twitch
  class Clip
    DATE_ATTRIBUTES = [:created_at]

    attr_reader :id, :title, :created_at, :url, :thumbnail_url, :view_count, 
      :language, :broadcaster_id, :creator_id, :game_id, :video_id, :embed_url

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