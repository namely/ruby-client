shared_examples_for "a model with an index action" do |instance_methods = []|
  describe ".all" do
    it "returns every model" do
      VCR.use_cassette("#{classname}_index") do
        objects = described_class.all

        expect(objects).not_to be_empty
        objects.each do |object|
          expect(object).to be_a described_class
          instance_methods.each do |instance_method|
            expect(object).to respond_to instance_method
          end
        end
      end
    end
  end
end
