module Namely
  class Country < RestfulModel
    def self.endpoint
      "countries"
    end

    def self.resource_name
      "countries"
    end

    private_class_method :endpoint, :resource_name
  end
end
