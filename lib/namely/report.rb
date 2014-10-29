module Namely
  class Report < RestfulModel
    def self.endpoint
      "reports"
    end

    def self.resource_name
      "reports"
    end

    private_class_method :endpoint, :resource_name
  end
end
