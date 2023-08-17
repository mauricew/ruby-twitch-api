# frozen_string_literal: true

require_relative 'cheermote_tier_image'

module Twitch
  ## Data class for Cheermote Tier images by themes
  class CheermoteTierImages
    ## The theme keys are `dark` and `light`.
    ## Each theme is a dictionary of formats: `animated` and `static`.
    ## Each format is a dictionary of sizes: `1`, `1.5`, `2`, `3`, and `4`.
    ## The value of each size contains the URL to the image.
    attr_reader :dark
    attr_reader :light

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", CheermoteTierImage.new(value)
      end
    end
  end
end
