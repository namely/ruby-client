shared_examples_for "a resource with an update action" do |valid_id, changes|
  describe "#update" do
    it "updates an existing object" do
      model = nil

      VCR.use_cassette("#{subject.endpoint}_show") do
        model = subject.find(valid_id)
      end

      changes.each do |attribute, value|
        expect(model[attribute]).not_to eq value
      end

      original_values = model.to_h.select do |attribute, _|
        changes.keys.include?(attribute)
      end

      VCR.use_cassette("#{subject.endpoint}_update") do
        model.update(changes)
      end

      VCR.use_cassette("#{subject.endpoint}_show_updated") do
        model = subject.find(valid_id)
      end
      changes.each do |attribute, value|
        expect(model[attribute]).to eq value
      end

      revert_changes(model, original_values)
    end
  end

  def revert_changes(model, original_values)
    VCR.use_cassette("#{subject.endpoint}_update_revert") do
      model.update(original_values)
    end
  end
end
