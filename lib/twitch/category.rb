# frozen_string_literal: true

module Twitch
  ## Data class for categories
  class Category
    ## A URL to an image of the game’s box art or streaming category.
    attr_reader :box_art_url

    ## The name of the game or category.
    attr_reader :name

    ## 	An ID that uniquely identifies the game or category.
    attr_reader :id

    ## Not always available:

    ## The ID that IGDB uses to identify this game.
    ## If the IGDB ID is not available to Twitch, this field is set to an empty string.
    attr_reader :igdb_id

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set :"@#{key}", value
      end
    end
  end
end
