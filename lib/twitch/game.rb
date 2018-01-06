module Twitch
  # A filterable category for a stream.  
  # (not necessarily limited to games, e.g. 'IRL')
  class Game
    # ID of the game.
    attr_reader :id
    # Name of the game
    attr_reader :name
    # Box art URL template.
    #
    # Substitute the {width} and {height} string tokens 
    # with your desired numeric values.
    attr_reader :box_art_url

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @box_art_url = attributes['box_art_url']
    end
  end
end
