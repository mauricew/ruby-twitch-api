require "time"

module Twitch
  class Video
    attr_reader :id, :title, :description, :language, :view_count, :created_at, :published_at, :thumbnail_url

    def initialize(attributes = {})
      attributes.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end
