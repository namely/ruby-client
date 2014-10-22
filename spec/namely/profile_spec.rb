require "spec_helper"

describe Namely::Profile do
  describe ".all" do
    it "returns every user profile" do
      VCR.use_cassette("profiles_index") do
        profiles = Namely::Profile.all

        expect(profiles.size).to eq 263
        expect(profiles).to be_all { |profile| profile.class == Namely::Profile }
        expect(profiles.first.first_name).to eq "Leighton"
        expect(profiles.first.last_name).to eq "Meester"
      end
    end
  end

  describe ".find" do
    it "finds a profile by its unique id" do
      VCR.use_cassette("profile_show") do
        profile_id = "20332458-c1fe-412f-bcb8-01622f04a35d"
        profile = Namely::Profile.find(profile_id)

        expect(profile.class).to eq Namely::Profile
        expect(profile.first_name).to eq "Leighton"
        expect(profile.last_name).to eq "Meester"
      end
    end

    it "raises an error if that user can't be found" do
      VCR.use_cassette("profile_show_missing") do
        expect { Namely::Profile.find("123456789") }.to raise_error Namely::NoSuchModelError
      end
    end
  end

  describe ".exists?" do
    it "returns true if a user exists" do
      VCR.use_cassette("profile_head") do
        profile_id = "20332458-c1fe-412f-bcb8-01622f04a35d"

        expect(Namely::Profile.exists?(profile_id)).to eq true
      end
    end

    it "returns false if a user doesn't exist" do
      VCR.use_cassette("profile_head_missing") do
        expect(Namely::Profile.exists?("123456789")).to eq false
      end
    end
  end
end
