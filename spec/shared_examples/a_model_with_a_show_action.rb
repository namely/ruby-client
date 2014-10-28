shared_examples_for "a model with a show action" do |model_attributes|
  def invalid_id
    "this-is-almost-certainly-not-the-id-of-any-model"
  end

  describe ".find" do
    it "finds a model by its unique id" do
      VCR.use_cassette("#{classname}_show") do
        object = described_class.find(model_attributes[:id])

        expect(object).to be_a described_class
        model_attributes.each do |method, value|
          expect(object.public_send(method)).to eq value
        end
      end
    end

    it "raises an error if that model can't be found" do
      VCR.use_cassette("#{classname}_show_missing") do
        expect { described_class.find(invalid_id) }.to raise_error Namely::NoSuchModelError
      end
    end
  end

  describe ".exists?" do
    it "returns true if a model exists" do
      VCR.use_cassette("#{classname}_head") do
        expect(described_class.exists?(model_attributes[:id])).to eq true
      end
    end

    it "returns false if a model doesn't exist" do
      VCR.use_cassette("#{classname}_head_missing") do
        expect(described_class.exists?(invalid_id)).to eq false
      end
    end
  end
end
