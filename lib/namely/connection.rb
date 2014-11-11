module Namely
  class Connection
    def initialize(options)
      @access_token = options.fetch(:access_token)
      @subdomain = options.fetch(:subdomain)
    rescue KeyError
      raise ArgumentError, "Please supply an access_token and subdomain."
    end

    def countries
      collection("countries")
    end

    def currency_types
      collection("currency_types")
    end

    def events
      collection("events")
    end

    def fields
      collection("profiles/fields")
    end

    def job_tiers
      collection("job_tiers")
    end

    def profiles
      collection("profiles")
    end

    def reports
      collection("reports")
    end

    private

    attr_reader :access_token, :subdomain

    def collection(endpoint)
      Namely::Collection.new(gateway(endpoint))
    end

    def gateway(endpoint)
      ResourceGateway.new(
        access_token: access_token,
        endpoint: endpoint,
        subdomain: subdomain,
      )
    end
  end
end
