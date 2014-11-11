module Namely
  class Error < StandardError
  end

  class NoSuchModelError < Error
  end

  class FailedRequestError < Error
  end
end
