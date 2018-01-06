module Twitch
  # An error returned by the API.
  class ApiError < StandardError
    # HTTP status code of the response.
    attr_reader :status_code
    # Body content of the response.
    attr_reader :body

    def initialize(status_code, body)
      @status_code = status_code
      @body = body

      msg = "The server returned error #{status_code}"
      super(msg)
    end
  end
end