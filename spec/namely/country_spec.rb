require "spec_helper"

describe Namely::Country do
  it_behaves_like "a model with an index action", [:id, :name, :subdivision_type]
  it_behaves_like(
    "a model with a show action",
    id: "US",
    name: "United States",
    subdivision_type: "State"
  )
end
