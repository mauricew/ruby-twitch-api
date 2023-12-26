# frozen_string_literal: true

require_relative 'cheermote_tier'

module Twitch
  ## Data class for Cheermotes, animated emotes that viewers can assign Bits to.
  class Cheermote
    ## The name portion of the Cheermote string that you use in chat to cheer Bits.
    ## The full Cheermote string is the concatenation of {prefix} + {number of Bits}.
    ## For example, if the prefix is “Cheer” and you want to cheer 100 Bits,
    ## the full Cheermote string is Cheer100.
    ## When the Cheermote string is entered in chat,
    ## Twitch converts it to the image associated with the Bits tier that was cheered.
    attr_reader :prefix

    ## A list of tier levels that the Cheermote supports.
    ## Each tier identifies the range of Bits that you can cheer at that tier level
    ## and an image that graphically identifies the tier level.
    attr_reader :tiers

    ## The type of Cheermote. Possible values are:
    ## * global_first_party — A Twitch-defined Cheermote that is shown in the Bits card.
    ## * global_third_party — A Twitch-defined Cheermote that is not shown in the Bits card.
    ## * channel_custom — A broadcaster-defined Cheermote.
    ## * display_only — Do not use; for internal use only.
    ## * sponsored — A sponsor-defined Cheermote.
    ##   When used, the sponsor adds additional Bits to the amount that the user cheered.
    ##   For example, if the user cheered Terminator100, the broadcaster might receive 110 Bits,
    ##   which includes the sponsor's 10 Bits contribution.
    attr_reader :type

    ## The order that the Cheermotes are shown in the Bits card.
    ## The numbers may not be consecutive. For example, the numbers may jump from 1 to 7 to 13.
    ## The order numbers are unique within a Cheermote type (for example, global_first_party)
    ## but may not be unique amongst all Cheermotes in the response.
    attr_reader :order

    ## The date and time when this Cheermote was last updated.
    attr_reader :last_updated

    ## A Boolean value that indicates whether this Cheermote provides
    ## a charitable contribution match during charity campaigns.
    attr_reader :is_charitable

    def initialize(attributes = {})
      attributes.each do |key, value|
        value = value.map { |tier| CheermoteTier.new(tier) } if key == 'tiers'

        instance_variable_set :"@#{key}", value
      end
    end
  end
end
