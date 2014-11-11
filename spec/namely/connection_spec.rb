require "spec_helper"

describe Namely::Connection do
  describe "#initialize" do
    context "when no provided an access token or subdomain" do
      it "raises an ArgumentError" do
        expect { Namely::Connection.new }.to raise_error ArgumentError
        expect { Namely::Connection.new(access_token: "token") }.
          to raise_error ArgumentError
        expect { Namely::Connection.new(subdomain: "subdomain") }.
          to raise_error ArgumentError
      end
    end
  end
end
