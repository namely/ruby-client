require "spec_helper"

describe Namely::ResourceGateway do
  def profile_gateway
    Namely::ResourceGateway.new(
      access_token: Namely.configuration.access_token,
      endpoint: "profiles",
      resource_name: "profiles",
      subdomain: Namely.configuration.subdomain
    )
  end

  def valid_id
    "20332458-c1fe-412f-bcb8-01622f04a35d"
  end

  def invalid_id
    "123456789"
  end

  describe "#json_index" do
    it "returns the parsed JSON representation of #index" do
      VCR.use_cassette("profiles_index") do
        profiles = profile_gateway.json_index

        expect(profiles).not_to be_empty
        expect(profiles.first).to have_key "first_name"
        expect(profiles.first).to have_key "last_name"
      end
    end
  end

  describe "#json_show" do
    it "returns the parsed JSON representation of #show" do
      VCR.use_cassette("profile_show") do
        profile = profile_gateway.json_show(valid_id)

        expect(profile["first_name"]).to eq "Leighton"
        expect(profile["last_name"]).to eq "Meester"
      end
    end
  end

  describe "#show_head" do
    it "returns an empty response if it succeeds" do
      VCR.use_cassette("profile_head") do
        expect(profile_gateway.show_head(valid_id)).to be_empty
      end
    end

    it "raises a RestClient::ResourceNotFound error if it fails" do
      VCR.use_cassette("profile_head_missing") do
        expect { profile_gateway.show_head(invalid_id) }.to raise_error RestClient::ResourceNotFound
      end
    end
  end
end
