module Namely
  class Connection
    # Instantiate a new connection to the server.
    #
    # @param [Hash] options
    # @option options [String] access_token (required)
    # @option options [String] subdomain (required)
    #
    # @example
    #   Namely.configure do |config|
    #     config.access_token = "your_access_token"
    #     config.subdomain = "your-organization"
    #   end
    #
    # @raise [KeyError] if access_token and subdomain aren't provided.
    #
    # @return [Connection]
    def initialize(options)
      @access_token = options.fetch(:access_token)
      @subdomain = options.fetch(:subdomain)
    rescue KeyError
      raise ArgumentError, "Please supply an access_token and subdomain."
    end

    # Return a Collection of countries.
    #
    # @return [Collection]
    def countries
      collection("countries")
    end

    # Return a Collection of currency types.
    #
    # @return [Collection]
    def currency_types
      collection("currency_types")
    end

    # Return a Collection of countries.
    #
    # @return [Collection]
    def events
      collection("events")
    end

    # Return a Collection of profile fields.
    #
    # @return [Collection]
    def fields
      collection("profiles/fields")
    end

    # Return a Collection of job tiers.
    #
    # @return [Collection]
    def job_tiers
      collection("job_tiers")
    end

    # Return a Collection of job titles.
    #
    # @return [Collection]
    def job_titles
      collection("job_titles")
    end

    # Return a Collection of profiles.
    #
    # @return [Collection]
    def profiles
      collection("profiles", paged: true)
    end

    # Return a Collection of reports.
    #
    # @return [Collection]
    def reports
      collection("reports")
    end

    private

    attr_reader :access_token, :subdomain

    def collection(endpoint, options = {})
      Namely::Collection.new(gateway(endpoint, options))
    end

    def gateway(endpoint, options = {})
      ResourceGateway.new(options.merge(
        access_token: access_token,
        endpoint: endpoint,
        subdomain: subdomain,
      ))
    end
  end
end
