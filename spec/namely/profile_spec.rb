require "spec_helper"

describe Namely::Profile do
  def valid_id
    "20332458-c1fe-412f-bcb8-01622f04a35d"
  end

  def invalid_id
    "123456789"
  end

  describe ".all" do
    it "returns every user profile" do
      VCR.use_cassette("profiles_index") do
        profiles = Namely::Profile.all

        expect(profiles).not_to be_empty
        profiles.each do |profile|
          expect(profile).to be_a Namely::Profile
          expect(profile).to respond_to :first_name
          expect(profile).to respond_to :last_name
        end
      end
    end
  end

  describe ".find" do
    it "finds a profile by its unique id" do
      VCR.use_cassette("profile_show") do
        profile = Namely::Profile.find(valid_id)

        expect(profile).to be_a Namely::Profile
        expect(profile.first_name).to eq "Leighton"
        expect(profile.last_name).to eq "Meester"
      end
    end

    it "raises an error if that user can't be found" do
      VCR.use_cassette("profile_show_missing") do
        expect { Namely::Profile.find(invalid_id) }.to raise_error Namely::NoSuchModelError
      end
    end
  end

  describe ".exists?" do
    it "returns true if a user exists" do
      VCR.use_cassette("profile_head") do
        expect(Namely::Profile.exists?(valid_id)).to eq true
      end
    end

    it "returns false if a user doesn't exist" do
      VCR.use_cassette("profile_head_missing") do
        expect(Namely::Profile.exists?(invalid_id)).to eq false
      end
    end
  end
end
