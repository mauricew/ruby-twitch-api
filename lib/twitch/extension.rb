# frozen_string_literal: true

module Twitch
  # A feature used to augment dynamic information on a stream.
  class Extension
    # ID of the extension.
    attr_reader :id
    # Version number of the extension.
    attr_reader :version
    # Name of the extension.
    attr_reader :name
    # Whether the extension is configured such that it can be activated.
    attr_reader :can_activate
    # The extension types that you can activate for this extension. Possible values are:
    # `component`, `mobile`, `overlay`, `panel`
    attr_reader :type

    # Optional attributes for extensions from `get` methods results

    # A Boolean value that determines the extension’s activation state.
    # If false, the user has not configured this component extension.
    attr_reader :active

    # Optional attributes for extensions with `component` type

    # The x-coordinate where the extension is placed.
    attr_reader :x
    # The y-coordinate where the extension is placed.
    attr_reader :y

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set :"@#{key}", value
      end
    end
  end
end
