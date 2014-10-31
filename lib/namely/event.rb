module Namely
  class Event < RestfulModel
    def self.endpoint
      "events"
    end

    private_class_method :endpoint
  end
end
