module Namely
  class Connection
    def initialize(options)
      @access_token = options.fetch(:access_token)
      @subdomain = options.fetch(:subdomain)
    rescue KeyError
      raise ArgumentError, "Please supply an access_token and subdomain."
    end

    def profiles
      profile_gateway = ResourceGateway.new(
        access_token: access_token,
        endpoint: "profiles",
        subdomain: subdomain,
      )
      Namely::Collection.new(profile_gateway)
    end

    private

    attr_reader :access_token, :subdomain
  end
end
