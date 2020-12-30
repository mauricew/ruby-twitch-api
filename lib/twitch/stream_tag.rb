module Twitch
  # A tag can be used for searching and filtering streams.
  class StreamTag
    # ID of the tag
    attr_reader :tag_id
    # Whether the tag was automatically generated
    attr_reader :is_auto
    # Hash containing localized names of the tag.
    attr_reader :localization_names
    # Hash containing localized descriptions of the tag.
    attr_reader :localization_descriptions

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end