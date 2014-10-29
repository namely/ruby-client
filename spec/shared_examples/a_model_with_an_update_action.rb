shared_examples_for "a model with an update action" do |valid_id, changes|
  describe "#update" do
    it "updates an existing object" do
      model = nil
      original_values = nil

      VCR.use_cassette("#{classname}_show") do
        model = Namely::Profile.find(valid_id)
      end
      expect(model.middle_name).to be_empty

      original_values = model.to_h.select { |attribute, _| changes.keys.include?(attribute) }

      VCR.use_cassette("#{classname}_update") do
        model.update(changes)
      end

      VCR.use_cassette("#{classname}_show_updated") do
        model = Namely::Profile.find(valid_id)
      end
      changes.each do |attribute, value|
        expect(model[attribute]).to eq value
      end

      revert_changes(model, original_values)
    end
  end

  def revert_changes(model, original_values)
    VCR.use_cassette("#{classname}_update_revert") do
      model.update(original_values)
    end
  end
end
