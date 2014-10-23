require "spec_helper"

describe Namely::Field do
  describe ".all" do
    it "returns every field" do
      VCR.use_cassette("fields_index") do
        fields = Namely::Field.all

        expect(fields).not_to be_empty
        expect(fields).to be_all { |field| field.class == Namely::Field }
      end
    end
  end
end
