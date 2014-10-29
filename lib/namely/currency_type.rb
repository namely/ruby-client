module Namely
  class CurrencyType < RestfulModel
    def self.endpoint
      "currency_types"
    end

    def self.resource_name
      "currency_types"
    end

    private_class_method :endpoint, :resource_name
  end
end
