shared_examples "a resource with a show action" do |model_attributes|
  def invalid_id
    "this-is-almost-certainly-not-the-id-of-any-model"
  end

  describe "#find" do
    it "finds a model by its unique id" do
      VCR.use_cassette("#{subject.endpoint}_show") do
        object = subject.find(model_attributes[:id])

        expect(object).to be_a Namely::Model
        model_attributes.each do |method, value|
          expect(object.public_send(method)).to eq value
        end
      end
    end

    it "raises an error if that model can't be found" do
      VCR.use_cassette("#{subject.endpoint}_show_missing") do
        expect { subject.find(invalid_id) }.to raise_error Namely::NoSuchModelError
      end
    end
  end

  describe "#exists?" do
    it "returns true if a model exists" do
      VCR.use_cassette("#{subject.endpoint}_head") do
        expect(subject.exists?(model_attributes[:id])).to eq true
      end
    end

    it "returns false if a model doesn't exist" do
      VCR.use_cassette("#{subject.endpoint}_head_missing") do
        expect(subject.exists?(invalid_id)).to eq false
      end
    end
  end
end
