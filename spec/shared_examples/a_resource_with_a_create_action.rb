shared_examples "a resource with a create action" do |model_attributes|
  def invalid_attributes
    {}
  end

  describe "#create" do
    it "creates a model based on a hash of attributes" do
      model = nil

      VCR.use_cassette("#{subject.endpoint}_create") do
        model = subject.create!(model_attributes)
      end

      expect(model).to respond_to :id
      expect(model.id).not_to be_empty
    end

    it "raises a FailedRequestError when the create action fails" do
      VCR.use_cassette("#{subject.endpoint}_create_failed") do
        expect { subject.create!(invalid_attributes) }.to raise_error Namely::FailedRequestError
      end
    end
  end
end
