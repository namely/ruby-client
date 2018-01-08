require "spec_helper"

describe Namely::Configuration do

  describe "#http_codes_to_retry" do
    it "is empty array by default" do
      expect(Namely.configuration.http_codes_to_retry).to eq []
    end

    it "accepts an array of intergers" do
      expected_result = http_codes = [504, 502]

      Namely.configure { |config| config.http_codes_to_retry = http_codes }

      expect(Namely.configuration.http_codes_to_retry).to eq expected_result
    end

    it "accepts a single integer" do
      http_code = 504
      expected_return = [http_code]

      Namely.configure { |config| config.http_codes_to_retry = http_code }

      expect(Namely.configuration.http_codes_to_retry).to eq expected_return
    end
  end

  describe "#retries" do
    it "is 0 by default" do
      expect(Namely.configuration.retries).to eq 0
    end

    it "accepts an interger representing the number of retries" do
      expected_result = number_of_retries = 3

      Namely.configure { |config| config.retries = number_of_retries }

      expect(Namely.configuration.retries).to eq expected_result
    end
  end
end
