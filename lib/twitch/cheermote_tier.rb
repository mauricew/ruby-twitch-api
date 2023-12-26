# frozen_string_literal: true

require_relative 'cheermote_tier_images'

module Twitch
  ## Data class for Cheermote Tier.
  ## Each tier identifies the range of Bits that you can cheer at that tier level
  ## and an image that graphically identifies the tier level.
  class CheermoteTier
    ## The minimum number of Bits that you must cheer at this tier level.
    ## The maximum number of Bits that you can cheer at this level
    ## is determined by the required minimum Bits of the next tier level minus 1.
    ## For example, if `min_bits` is 1 and `min_bits` for the next tier is 100,
    ## the Bits range for this tier level is 1 through 99.
    ## The minimum Bits value of the last tier is the maximum number of Bits you can cheer
    ## using this Cheermote. For example, 10000.
    attr_reader :min_bits

    ## 	The tier level. Possible tiers are:
    ## * 1
    ## * 100
    ## * 500
    ## * 1000
    ## * 5000
    ## * 10000
    ## * 100000
    attr_reader :id

    ## The hex code of the color associated with this tier level (for example, `#979797`).
    attr_reader :color

    ## The animated and static image sets for the Cheermote.
    ## The dictionary of images is organized by theme, format, and size.
    ## The theme keys are `dark` and `light`.
    ## Each theme is a dictionary of formats: `animated` and `static`.
    ## Each format is a dictionary of sizes: `1`, `1.5`, `2`, `3`, and `4`.
    ## The value of each size contains the URL to the image.
    attr_reader :images

    ## A Boolean value that determines whether users can cheer at this tier level.
    attr_reader :can_cheer

    ## A Boolean value that determines whether this tier level is shown in the Bits card.
    ## Is `true` if this tier level is shown in the Bits card.
    attr_reader :show_in_bits_card

    def initialize(attributes = {})
      attributes.each do |key, value|
        value = CheermoteTierImages.new(value) if key == 'images'

        instance_variable_set :"@#{key}", value
      end
    end
  end
end
