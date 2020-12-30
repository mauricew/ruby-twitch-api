module Twitch
  # A determination if AutoMod would allow a message in a particular channel's chat.
  class AutomodMessageStatus
    # ID of the message. Matches the field of the same name passed in the request.
    attr_reader :msg_id
    # Whether the message would meet AutoMod requirements for the channel.
    attr_reader :is_permitted

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
