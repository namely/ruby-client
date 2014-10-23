require "spec_helper"

describe Namely::CurrencyType do
  describe ".all" do
    it "returns every currency type" do
      VCR.use_cassette("currency_type_index") do
        currency_types = Namely::CurrencyType.all

        expect(currency_types).not_to be_empty
        currency_types.each do |currency_type|
          expect(currency_type).to be_a Namely::CurrencyType
        end
      end
    end
  end
end
