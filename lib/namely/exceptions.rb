module Namely
  class Error < StandardError
  end

  class ImproperlyConfiguredError < Error
  end

  class NoSuchModelError < Error
  end

  class FailedRequestError < Error
  end
end
