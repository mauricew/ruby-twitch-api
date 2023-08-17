# frozen_string_literal: true

module Twitch
  ## Data class for Cheermote Tier image, static and animated
  class CheermoteTierImage
    ## Each theme is a dictionary of formats: `animated` and `static`.
    ## Each format is a dictionary of sizes: `1`, `1.5`, `2`, `3`, and `4`.
    ## The value of each size contains the URL to the image.
    attr_reader :animated
    attr_reader :static

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
