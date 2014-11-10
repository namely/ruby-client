shared_examples "a resource with an index action" do |instance_methods = []|
  it "returns every model" do
    VCR.use_cassette("#{subject.endpoint}_index") do
      objects = subject.all

      expect(objects).not_to be_empty
      objects.each do |object|
        expect(object).to be_a Namely::Model
        instance_methods.each do |instance_method|
          expect(object).to respond_to instance_method
        end
      end
    end
  end
end
