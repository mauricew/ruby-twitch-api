require "time"

module Twitch
  class Video
    DATE_ATTRIBUTES = [:created_at, :published_at]

    attr_reader :id, :title, :description, :language, :view_count, :created_at, :published_at, :thumbnail_url

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
