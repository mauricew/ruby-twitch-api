module Twitch
  class Game
    attr_reader :id, :name, :box_art_url

    def initialize(attributes = {})
      attributes.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end
