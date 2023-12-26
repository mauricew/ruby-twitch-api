# frozen_string_literal: true

module Twitch
  # A dictionary (Hash) of Extensions by their types and placements
  class ExtensionsByTypes
    # A dictionary that contains the data for a panel extension.
    # The dictionary’s key is a sequential number beginning with 1.
    # The following fields contain the panel’s data for each key.
    attr_reader :panel

    # A dictionary that contains the data for a video-overlay extension.
    # The dictionary’s key is a sequential number beginning with 1.
    # The following fields contain the overlay’s data for each key.
    attr_reader :overlay

    # A dictionary that contains the data for a video-component extension.
    # The dictionary’s key is a sequential number beginning with 1.
    # The following fields contain the component’s data for each key.
    attr_reader :component

    def initialize(attributes = {})
      %w[panel overlay component].each do |type|
        instance_variable_set(
          :"@#{type}",
          attributes[type].transform_values do |extension_data|
            Extension.new(extension_data)
          end
        )
      end
    end
  end
end
