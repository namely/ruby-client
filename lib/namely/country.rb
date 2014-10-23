module Namely
  class Country < RestfulModel
    def self.endpoint
      "countries"
    end

    def self.resource_name
      "countries"
    end
  end
end
