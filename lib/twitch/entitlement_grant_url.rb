module Twitch
  # A URL that can be used to notify users of an entitlement.
  class EntitlementGrantUrl
    # The URL to upload an entitlement manifest.
    # See the Twitch API documentation on how to use this.
    attr_reader :url

    def initialize(attributes = {})
      @url = attributes['url']
    end
    
  end
end