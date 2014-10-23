require "spec_helper"

describe Namely::Country do
  def valid_id
    "US"
  end

  def invalid_id
    "not_a_valid_country_id"
  end

  describe ".all" do
    it "returns every country" do
      VCR.use_cassette("country_index") do
        countries = Namely::Country.all

        expect(countries).not_to be_empty
        countries.each do |country|
          expect(country).to be_a Namely::Country
          expect(country).to respond_to :id
          expect(country).to respond_to :name
          expect(country).to respond_to :subdivision_type
        end
      end
    end
  end

  describe ".find" do
    it "finds a country by its unique id" do
      VCR.use_cassette("country_show") do
        country = Namely::Country.find(valid_id)

        expect(country).to be_a Namely::Country
        expect(country.id).to eq valid_id
        expect(country.name).to eq "United States"
        expect(country.subdivision_type).to eq "State"
      end
    end

    it "raises an error if that user can't be found" do
      VCR.use_cassette("country_show_missing") do
        expect { Namely::Country.find(invalid_id) }.to raise_error Namely::NoSuchModelError
      end
    end
  end

  describe ".exists?" do
    it "returns true if a country exists" do
      VCR.use_cassette("country_head") do
        expect(Namely::Country.exists?(valid_id)).to eq true
      end
    end

    it "returns false if a country doesn't exist" do
      VCR.use_cassette("country_head_missing") do
        expect(Namely::Country.exists?(invalid_id)).to eq false
      end
    end
  end
end
