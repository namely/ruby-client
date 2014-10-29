module Namely
  class Country < RestfulModel
    def self.endpoint
      "countries"
    end

    private_class_method :endpoint
  end
end
