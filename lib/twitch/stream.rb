require "time"

module Twitch
  class Stream
    attr_reader :id, :user_id, :game_id, :community_ids, :type, :title, :viewer_count, :started_at, :language, :thumbnail_url
    DATE_ATTRIBUTES = [:started_at]

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