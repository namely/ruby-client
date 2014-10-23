module Namely
  class CurrencyType < RestfulModel
    def self.endpoint
      "currency_types"
    end

    def self.resource_name
      "currency_types"
    end
  end
end
