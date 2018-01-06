module Twitch
  class User
    # ID of the user.
    attr_reader :id
    # Unformatted (lowercase) username of the user.
    attr_reader :login
    # Formatted username of the user.
    attr_reader :display_name
    # Represents a special role of a user.
    # (global mod, admin, staff)
    attr_reader :type
    # Represents a special broadcaster role of a user.
    # (partner, affilaite)
    attr_reader :broadcaster_type
    # Description/biographical info of a user.
    attr_reader :description
    # URL to the user's profile image.
    attr_reader :profile_image_url
    # URL to the image displayed in the video box
    # when the stream is offline.
    attr_reader :offline_image_url
    # Total number of visits to the user's stream page.
    attr_reader :view_count

    def initialize(attributes = {})
      attributes.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end
