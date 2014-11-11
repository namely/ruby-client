require "spec_helper"

describe Namely::ResourceGateway do
  def access_token
    ENV.fetch("TEST_ACCESS_TOKEN")
  end

  def subdomain
    ENV.fetch("TEST_SUBDOMAIN")
  end

  def gateway
    @gateway ||= Namely::ResourceGateway.new(
      access_token: access_token,
      endpoint: "widgets",
      resource_name: "widgets",
      subdomain: subdomain,
    )
  end

  def valid_id
    "this-is-a-valid-id"
  end

  def invalid_id
    "this-is-not-a-valid-id"
  end

  describe "#json_index" do
    it "returns the parsed JSON representation of #index" do
      stub_request(
        :get,
        "https://#{subdomain}.namely.com/api/v1/widgets"
      ).with(
        query: {
          access_token: access_token,
          limit: :all
        }
      ).to_return(
        body: "{\"widgets\": [\"woo!\"]}",
        status: 200
      )

      expect(gateway.json_index).to eq ["woo!"]
    end
  end

  describe "#json_show" do
    it "returns the parsed JSON representation of #show" do
      stub_request(
        :get,
        "https://#{subdomain}.namely.com/api/v1/widgets/#{valid_id}"
      ).with(
        query: {
          access_token: access_token
        }
      ).to_return(
        body: "{\"widgets\": [{\"name\": \"wilbur\", \"favorite_color\": \"chartreuse\"}]}",
        status: 200
      )

      widget = gateway.json_show(valid_id)

      expect(widget["name"]).to eq "wilbur"
      expect(widget["favorite_color"]).to eq "chartreuse"
    end
  end

  describe "#show_head" do
    it "returns an empty response if it succeeds" do
      stub_request(
        :head,
        "https://#{subdomain}.namely.com/api/v1/widgets/#{valid_id}"
      ).with(
        query: {
          access_token: access_token
        }
      ).to_return(
        body: "",
        status: 200
      )

      expect(gateway.show_head(valid_id)).to be_empty
    end

    it "raises a RestClient::ResourceNotFound error if it fails" do
      stub_request(
        :head,
        "https://#{subdomain}.namely.com/api/v1/widgets/#{invalid_id}"
      ).with(
        query: {
          access_token: access_token
        }
      ).to_return(
        status: 404
      )

      expect { gateway.show_head(invalid_id) }.to raise_error RestClient::ResourceNotFound
    end
  end
end
