require "spec_helper"

describe Namely::Connection do
  describe "#initialize" do
    context "when no provided an access token or subdomain" do
      it "raises an ArgumentError" do
        expect { Namely::Connection.new }.to raise_error ArgumentError
        expect { Namely::Connection.new(access_token: "token") }.to raise_error ArgumentError
        expect { Namely::Connection.new(subdomain: "subdomain") }.to raise_error ArgumentError
      end
    end
  end

  COLLECTION_TYPES = [
    :countries,
    :currency_types,
    :events,
    :fields,
    :job_tiers,
    :profiles,
    :reports,
  ]

  COLLECTION_TYPES.each do |collection_type|
    describe "##{collection_type}" do
      it "returns a Collection object" do
        expect(conn.public_send(collection_type)).to be_a Namely::Collection
      end
    end
  end

  def conn
    Namely::Connection.new(
      access_token: "token",
      subdomain: "subdomain",
    )
  end
end
