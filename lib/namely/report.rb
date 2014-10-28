module Namely
  class Report < RestfulModel
    def self.endpoint
      "reports"
    end

    def self.resource_name
      "reports"
    end
  end
end
