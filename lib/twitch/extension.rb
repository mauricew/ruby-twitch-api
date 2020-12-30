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

    # An array containing the display format of the extension.
    # Valid values can include `component`, `mobile`, `panel`, and `overlay`.

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
