require "spec_helper"

describe Namely::Collection do
  describe "profile collections" do
    subject { collection("profiles") }

    it_behaves_like "a resource with an index action", [:first_name, :last_name]

    it_behaves_like(
      "a resource with a show action",
      id: "20332458-c1fe-412f-bcb8-01622f04a35d",
      first_name: "Leighton",
      last_name: "Meester"
    )

    it_behaves_like(
      "a resource with a create action",
      first_name: "Beardsly",
      last_name: "McDog",
      email: "beardsly-#{Time.now.utc.to_f}@namely.com"
    )
  end

  def collection(endpoint)
    gateway = Namely::ResourceGateway.new(
      access_token: ENV.fetch("TEST_ACCESS_TOKEN"),
      endpoint: endpoint,
      subdomain: ENV.fetch("TEST_SUBDOMAIN"),
    )
    Namely::Collection.new(gateway)
  end
end
