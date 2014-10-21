require "spec_helper"

describe Namely::Client do
  describe "#profiles" do
    it "successfully requests a list of user profiles" do
      VCR.use_cassette("get_profiles") do
        expect(Namely::Client.new.profiles["meta"]["status"]).to eq 200
      end
    end
  end
end
