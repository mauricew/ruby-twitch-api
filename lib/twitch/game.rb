module Twitch
  class Game
    attr_reader :id, :name, :box_art_url

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @box_art_url = attributes['box_art_url']
    end
  end
end
