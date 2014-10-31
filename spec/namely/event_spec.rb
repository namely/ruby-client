require "spec_helper"

describe Namely::Event do
  it_behaves_like "a model with an index action", [:type]

  it_behaves_like(
    "a model with a show action",
    id: "e5573698-3934-4abf-99cf-577b526d4789",
    type: "recent_arrival",
  )
end
