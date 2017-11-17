module Twitch
  class ApiError < StandardError
    attr_reader :status_code, :body

    def initialize(status_code, body)
      @status_code = status_code
      @body = body

      msg = "The server returned error #{status_code}"
      super(msg)
    end
  end
end