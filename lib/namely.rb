require "json"
require "ostruct"
require "rest_client"

require "namely/improperly_configured_error"
require "namely/no_such_model_error"

require "namely/resource_gateway"
require "namely/restful_model"

require "namely/country"
require "namely/currency_type"
require "namely/field"
require "namely/profile"
require "namely/report"

require "namely/version"

module Namely
  class << self
    attr_writer :configuration
  end

  # Return the current configuration.
  #
  # @raise [ImproperlyConfiguredError] if the subdomain or access token
  #   haven't been configured.
  #
  # @return [Configuration]
  def self.configuration
    @configuration || raise(
      ImproperlyConfiguredError,
      "Before using the Namely gem, you'll need to configure it with `Namely.configure`."
    )
  end

  # Set the configuration variables (the subdomain and access token)
  # that allow the Namely gem to access your account.
  #
  # @yieldparam [Configuration] configuration the Configuration
  #   object, the attributes of which can be set in the block.
  #
  # @example
  #   Namely.configure do |config|
  #     config.access_token = "your_access_token"
  #     config.subdomain = "your-organization"
  #   end
  #
  # @return [void]
  def self.configure
    @configuration ||= Configuration.new
    yield configuration
  end

  # Return a resource gateway for interfacing with a given resource.
  #
  # @param [String] resource_name
  # @param [String] endpoint
  #
  # @return [ResourceGateway]
  def self.resource_gateway(resource_name, endpoint)
    configuration.resource_gateway(resource_name, endpoint)
  end

  class Configuration
    attr_writer :access_token, :subdomain

    # Get the access token.
    #
    # @raise [ImproperlyConfiguredError] if the access token hasn't
    #   been configured.
    #
    # @return [String] the access token
    def access_token
      @access_token || raise_missing_variable_error(:access_token)
    end

    # Get the subdomain.
    #
    # @raise [ImproperlyConfiguredError] if the subdomain hasn't been
    #   configured.
    #
    # @return [String] the subdomain
    def subdomain
      @subdomain || raise_missing_variable_error(:subdomain)
    end

    # Create a resource gateway for interfacing with a given resource.
    #
    # @param [String] resource_name
    # @param [String] endpoint
    #
    # @return [ResourceGateway]
    def resource_gateway(resource_name, endpoint)
      Namely::ResourceGateway.new(
        access_token: access_token,
        endpoint: endpoint,
        resource_name: resource_name,
        subdomain: subdomain
      )
    end

    private

    def raise_missing_variable_error(variable)
      raise(
        ImproperlyConfiguredError,
        "The Namely `#{variable}` configuration variable hasn't been set... did you set it when you called `Namely.configure`?"
      )
    end
  end
end
