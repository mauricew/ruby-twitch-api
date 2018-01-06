module Twitch
  class EntitlementGrantUrl
    attr_reader :url

    def initialize(attributes = {})
      @url = attributes['url']
    end
    
  end
end