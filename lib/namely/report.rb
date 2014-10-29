module Namely
  class Report < RestfulModel
    def self.endpoint
      "reports"
    end

    private_class_method :endpoint
  end
end
