require "spec_helper"

describe Namely::JobTier do
  it_behaves_like "a model with an index action", [:title]
end
