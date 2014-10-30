require "spec_helper"

describe Namely::Profile do
  it_behaves_like "a model with an index action", [:first_name, :last_name]

  it_behaves_like(
    "a model with a show action",
    id: "20332458-c1fe-412f-bcb8-01622f04a35d",
    first_name: "Leighton",
    last_name: "Meester"
  )

  it_behaves_like(
    "a model with a create action",
    first_name: "Beardsly",
    last_name: "McDog",
    email: "beardsly-#{Time.now.utc.to_f}@namely.com"
  )
end
