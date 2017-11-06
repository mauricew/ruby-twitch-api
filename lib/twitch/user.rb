module Twitch
  class User
    # All fields are read-only until update support is implemented
    attr_reader :id, :login, :display_name, :type, :broadcaster_type, :description, :profile_image_url, :offline_image_url, :view_count

    def initialize(attributes = {})
      attributes.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end
