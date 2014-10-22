require "spec_helper"

describe Namely::Client do
  def client
    Namely::Client.new(
      Namely.configuration.access_token,
      Namely.configuration.site_name
    )
  end

  describe "#json_index" do
    it "returns the parsed JSON representation of #index" do
      VCR.use_cassette("profiles_index") do
        profiles = client.json_index("profiles")

        expect(profiles.size).to eq 263
        expect(profiles.first["first_name"]).to eq "Leighton"
        expect(profiles.first["last_name"]).to eq "Meester"
      end
    end
  end

  describe "#json_show" do
    it "returns the parsed JSON representation of #show" do
      VCR.use_cassette("profile_show") do
        profile_id = "20332458-c1fe-412f-bcb8-01622f04a35d"

        profile = client.json_show("profiles", profile_id)

        expect(profile["first_name"]).to eq "Leighton"
        expect(profile["last_name"]).to eq "Meester"
      end
    end
  end

  describe "#show_head" do
    it "returns an empty response if it succeeds" do
      VCR.use_cassette("profile_head") do
        profile_id = "20332458-c1fe-412f-bcb8-01622f04a35d"

        expect(client.show_head("profiles", profile_id)).to be_empty
      end
    end

    it "raises a RestClient::ResourceNotFound error if it fails" do
      VCR.use_cassette("profile_head_missing") do
        profile_id = "123456789"

        expect { client.show_head("profiles", profile_id) }.to raise_error RestClient::ResourceNotFound
      end
    end
  end
end
