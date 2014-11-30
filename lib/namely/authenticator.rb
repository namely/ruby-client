require "cgi"

module Namely
  class Authenticator
    # Return a new Authenticator instance.
    #
    # @param [Hash] options
    # @option options [String] client_id
    # @option options [String] client_secret
    #
    # @example
    #   authenticator = Authenticator.new(
    #     client_id: "my-client-id",
    #     client_secret: "my-client-secret"
    #   )
    #
    # @return [Authenticator]
    def initialize(options)
      @client_id = options.fetch(:client_id)
      @client_secret = options.fetch(:client_secret)
    end

    # Returns a URL to begin the authorization code workflow. If you
    # provide a redirect_uri you can receive the server's response.
    #
    # @param [Hash] options
    # @option options [String] host (optional)
    # @option options [String] protocol (optional, defaults to "https")
    # @option options [String] subdomain (required)
    # @option options [String] redirect_uri (optional)
    #
    # @return [String]
    def authorization_code_url(options)
      URL.new(options.merge(
        path: "/api/v1/oauth2/authorize",
        params: {
          response_type: "code",
          approve: "true",
          client_id: client_id,
        },
      )).to_s
    end

    # Request an access token and refresh token.
    #
    # @param [Hash] options
    # @option options [String] code (required)
    # @option options [String] redirect_uri (required)
    # @option options [String] subdomain (required)
    #
    # @example
    #   authenticator = Authenticator.new(
    #     client_id: "my-client-id",
    #     client_secret: "my-client-secret"
    #   )
    #
    #   tokens = authenticator.retrieve_tokens(
    #     code: "my-code",
    #     subdomain: "my-subdomain",
    #     redirect_uri: "my-redirect-uri"
    #   )
    #
    #   tokens["access_token"] # => "my-access-token"
    #   tokens["refresh_token"] # => "my-refresh-token"
    #   tokens["expires_in"] # => 1234
    #   tokens["token_type"] # => "bearer"
    #
    # @return [Hash]
    def retrieve_tokens(options)
      request_tokens(
        options,
        grant_type: "authorization_code",
        code: options.fetch(:code),
      )
    end

    # Get an updated access token using the refresh token.
    #
    # @param [Hash] options
    # @option options [String] redirect_uri (required)
    # @option options [String] refresh_token (required)
    # @option options [String] subdomain (required)
    #
    # @example
    #   authenticator = Authenticator.new(
    #     client_id: "my-client-id",
    #     client_secret: "my-client-secret"
    #   )
    #
    #   tokens = authenticator.refresh_access_token(
    #     redirect_uri: "my-redirect-uri",
    #     refresh_token: "my-refresh-token",
    #     subdomain: "my-subdomain"
    #   )
    #
    #   tokens["access_token"] # => "my-access-token"
    #   tokens["expires_in"] # => 1234
    #   tokens["token_type"] # => "bearer"
    #
    # @return [Hash]
    def refresh_access_token(options)
      request_tokens(
        options,
        grant_type: "refresh_token",
        refresh_token: options.fetch(:refresh_token),
      )
    end

    # Return the profile of the user accessing the API.
    #
    # @param [Hash] options
    # @option options [String] access_token (required)
    # @option options [String] subdomain (required)
    #
    # @return [Model] the profile of the current user.
    def current_user(options)
      access_token = options.fetch(:access_token)
      subdomain = options.fetch(:subdomain)

      user_url = URL.new(options.merge(
        params: {
          access_token: access_token,
        },
        path: "/api/v1/profiles/me",
      )).to_s

      response = RestClient.get(
        user_url,
        accept: :json,
      )
      build_profile(
        access_token,
        subdomain,
        JSON.parse(response)["profiles"].first
      )
    end

    private

    attr_reader :client_id, :client_secret

    def request_tokens(url_options, post_params)
      response = RestClient.post(
        URL.new(url_options.merge(path: "/api/v1/oauth2/token")).to_s,
        {
          client_id: client_id,
          client_secret: client_secret,
        }.merge(post_params),
      )
      JSON.parse(response)
    end

    def build_profile(access_token, subdomain, attributes)
      profile_gateway = ResourceGateway.new(
        access_token: access_token,
        endpoint: "profiles",
        subdomain: subdomain,
      )
      Model.new(profile_gateway, attributes)
    end

    class URL
      def initialize(options)
        @options = options
      end

      def to_s
        "#{protocol}://#{host}#{path}?#{query}"
      end

      private

      attr_reader :options

      def protocol
        options.fetch(:protocol, "https")
      end

      def host
        if options.has_key?(:subdomain)
          "#{options[:subdomain]}.namely.com"
        else
          options.fetch(:host)
        end
      end

      def path
        options.fetch(:path)
      end

      def query
        params.
          map { |key, value| "#{CGI.escape(key.to_s)}=#{CGI.escape(value)}" }.
          join("&")
      end

      def params
        options.fetch(:params, {}).merge(optional_params)
      end

      def optional_params
        [:redirect_uri, :state].inject({}) do |additional_params, key|
          if options.has_key?(key)
            additional_params[key] = options[key]
          end
          additional_params
        end
      end
    end
  end
end
