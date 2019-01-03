module Twitch
  # A user that is a leader for bits.
  class BitsLeader
    # ID of the user giving bits.
    attr_reader :user_id
    # Display name of the user giving bits.
    attr_reader :user_name
    # Ranking of the user giving bits.
    # Reflects the parent object's date range.
    attr_reader :rank
    # Number of bits given in the parent object's date range.
    attr_reader :score

    def initialize(attributes = {})
      @user_id = attributes['user_id']
      @user_name = attributes['user_name']
      @rank = attributes['rank']
      @score = attributes['score']
    end
  end
end