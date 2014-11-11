require "spec_helper"

describe Namely::Collection do
  describe "country collections" do
    subject { collection("countries") }

    it_behaves_like(
      "a resource with an index action",
      [:id, :name, :subdivision_type]
    )

    it_behaves_like(
      "a resource with a show action",
      id: "US",
      name: "United States",
      subdivision_type: "State"
    )
  end

  describe "currency type collections" do
    subject { collection("currency_types") }

    it_behaves_like "a resource with an index action"
  end

  describe "event collections" do
    subject { collection("events") }

    it_behaves_like "a resource with an index action", [:type]

    it_behaves_like(
      "a resource with a show action",
      id: "e5573698-3934-4abf-99cf-577b526d4789",
      type: "recent_arrival",
    )
  end

  describe "field collections" do
    subject { collection("profiles/fields") }

    it_behaves_like "a resource with an index action"
  end

  describe "job tier collections" do
    subject { collection("job_tiers") }

    it_behaves_like "a resource with an index action", [:title]
  end

  describe "profile collections" do
    subject { collection("profiles") }

    it_behaves_like(
      "a resource with an index action",
      [:first_name, :last_name]
    )

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

  describe "report collections" do
    subject { collection("reports") }

    it_behaves_like(
      "a resource with a show action",
      id: "bbf089f6-90c5-473c-8928-058014a462c9"
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
