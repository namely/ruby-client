module Namely
  class CurrencyType < RestfulModel
    def self.endpoint
      "currency_types"
    end

    private_class_method :endpoint
  end
end
