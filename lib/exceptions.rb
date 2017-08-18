module Exceptions
  class ResponseMessageNotFoundError < StandardError
    def message
      "Response message not found, the system administrator has been notified."
    end
  end
end