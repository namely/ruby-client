require "spec_helper"

describe "integration tests" do
  describe "country collections" do
    subject { conn.countries }

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
    subject { conn.currency_types }

    it_behaves_like "a resource with an index action"
  end

  describe "event collections" do
    subject { conn.events }

    it_behaves_like "a resource with an index action", [:type]

    it_behaves_like(
      "a resource with a show action",
      id: "e5573698-3934-4abf-99cf-577b526d4789",
      type: "recent_arrival",
    )
  end

  describe "field collections" do
    subject { conn.fields }

    it_behaves_like "a resource with an index action"
  end

  describe "job tier collections" do
    subject { conn.job_tiers }

    it_behaves_like "a resource with an index action", [:title]
  end

  describe "job title collections" do
    subject { conn.job_titles }

    it_behaves_like "a resource with an index action", [:title]
  end

  describe "profile collections" do
    subject { conn.profiles }

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

    it_behaves_like(
      "a resource with an update action",
      "20332458-c1fe-412f-bcb8-01622f04a35d",
      middle_name: "Beardsly"
    )
  end

  describe "report collections" do
    subject { conn.reports }

    it_behaves_like(
      "a resource with a show action",
      id: "bbf089f6-90c5-473c-8928-058014a462c9"
    )
  end

  def conn
    Namely::Connection.new(
      access_token: ENV.fetch("TEST_ACCESS_TOKEN"),
      subdomain: ENV.fetch("TEST_SUBDOMAIN"),
    )
  end
end
