require "spec_helper"
require "cgi"
require "uri"

describe Namely::Authenticator do
  describe "#auth_code_url" do
    it "returns a URL to begin the authorization code URL flow" do
      authenticator = described_class.new(
        client_id: "MY_CLIENT_ID",
        client_secret: "MY_CLIENT_SECRET",
      )

      authorization_code_url = authenticator.authorization_code_url(
        subdomain: "ellingsonmineral",
        redirect_uri: "http://www.example.com/authenticated",
      )

      parsed_uri = URI(authorization_code_url)
      parsed_query = CGI.parse(parsed_uri.query)
      expect(parsed_uri.scheme).to eq "https"
      expect(parsed_uri.host).to eq "ellingsonmineral.namely.com"
      expect(parsed_uri.path).to eq "/api/v1/oauth2/authorize"
      expect(parsed_query).to eq(
        "response_type" => ["code"],
        "approve" => ["true"],
        "client_id" => ["MY_CLIENT_ID"],
        "redirect_uri" => ["http://www.example.com/authenticated"],
      )
    end

    it "allows the redirect_uri to be omitted" do
      authenticator = described_class.new(
        client_id: "MY_CLIENT_ID",
        client_secret: "MY_CLIENT_SECRET",
      )

      authorization_code_url = authenticator.authorization_code_url(
        subdomain: "ellingsonmineral",
      )

      parsed_uri = URI(authorization_code_url)
      parsed_query = CGI.parse(parsed_uri.query)
      expect(parsed_query).to eq(
        "response_type" => ["code"],
        "approve" => ["true"],
        "client_id" => ["MY_CLIENT_ID"],
      )
    end

    it "escapes reserved characters in query parameters" do
      authenticator = described_class.new(
        client_id: "MY_CLIENT_ID",
        client_secret: "MY_CLIENT_SECRET",
      )
      redirect_uri = "http://example.com/?auth=true&provider=namely"

      authorization_code_url = authenticator.authorization_code_url(
        subdomain: "ellingsonmineral",
        redirect_uri: redirect_uri,
      )

      parsed_uri = URI(authorization_code_url)
      parsed_query = CGI.parse(parsed_uri.query)
      expect(parsed_query["redirect_uri"]).to eq [redirect_uri]
    end

    it "allows the host and protocol to be overridden" do
      authenticator = described_class.new(
        client_id: "MY_CLIENT_ID",
        client_secret: "MY_CLIENT_SECRET",
      )

      authorization_code_url = authenticator.authorization_code_url(
        protocol: "http",
        host: "testing.example.com",
      )

      parsed_uri = URI(authorization_code_url)
      expect(parsed_uri.scheme).to eq "http"
      expect(parsed_uri.host).to eq "testing.example.com"
    end
  end

  describe "#retrieve_tokens" do
    it "exchanges an authorization code for access and refresh tokens" do
      erb_settings = {
        erb: {
          access_token: "MY_ACCESS_TOKEN",
          refresh_token: "MY_REFRESH_TOKEN",
        }
      }

      VCR.use_cassette("token", erb_settings) do
        authenticator = described_class.new(
          client_id: ENV.fetch("CLIENT_ID"),
          client_secret: ENV.fetch("CLIENT_SECRET"),
        )

        tokens = authenticator.retrieve_tokens(
          subdomain: ENV.fetch("TEST_SUBDOMAIN"),
          code: ENV.fetch("AUTH_CODE"),
          redirect_uri: ENV.fetch("CLIENT_REDIRECT_URI"),
        )

        expect(tokens).to eq(
          "access_token" => "MY_ACCESS_TOKEN",
          "refresh_token" => "MY_REFRESH_TOKEN",
          "expires_in" => 899,
          "token_type" => "bearer",
        )
      end
    end
  end

  describe "#refresh_access_token" do
    it "uses a refresh token to retrieve a new access token" do
      erb_settings = {
        erb: {
          access_token: "MY_ACCESS_TOKEN",
        }
      }

      VCR.use_cassette("token_refresh", erb_settings) do
        authenticator = described_class.new(
          client_id: ENV.fetch("CLIENT_ID"),
          client_secret: ENV.fetch("CLIENT_SECRET"),
        )

        tokens = authenticator.refresh_access_token(
          subdomain: ENV.fetch("TEST_SUBDOMAIN"),
          refresh_token: ENV.fetch("TEST_REFRESH_TOKEN"),
          redirect_uri: ENV.fetch("CLIENT_REDIRECT_URI"),
        )

        expect(tokens).to eq(
          "access_token" => "MY_ACCESS_TOKEN",
          "expires_in" => 899,
          "token_type" => "bearer",
        )
      end
    end
  end

  describe "#current_user" do
    it "returns the profile of the current user" do
      VCR.use_cassette("current_user") do
        authenticator = described_class.new(
          client_id: "MY_CLIENT_ID",
          client_secret: "MY_CLIENT_SECRET",
        )

        profile = authenticator.current_user(ENV.fetch("TEST_ACCESS_TOKEN"))

        expect(profile.id).to eq "459748d5-608c-4dce-bca9-49a066d7f3d0"
      end
    end
  end
end
