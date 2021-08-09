module Twitch
  class EventSub
    attr_reader :id
    attr_reader :type
    attr_reader :transport
    attr_reader :status
    attr_reader :condition

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
