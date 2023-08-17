# frozen_string_literal: true

module Twitch
  ## A user who can edit broadcast content, settings, etc.
  class Editor
    ## An ID that uniquely identifies a user with editor permissions.
    attr_reader :user_id

    ## The user’s display name.
    attr_reader :user_name

    ## The date and time when the user became one of the broadcaster’s editors.
    attr_reader :created_at

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
