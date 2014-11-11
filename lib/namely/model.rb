require "ostruct"

module Namely
  class Model < OpenStruct
    def initialize(resource_gateway, attributes)
      @resource_gateway = resource_gateway
      super(attributes)
    end

    # Try to persist the current object by creating a new
    # object on the server. Raise an
    # error if the object can't be saved.
    #
    # @raise [FailedRequestError] if the request failed for any reason.
    #
    # @return [RestfulModel] the model itself, if saving succeeded.
    def save!
      self.id = resource_gateway.create(to_h)
      self
    rescue RestClient::Exception => e
      raise FailedRequestError, e.message
    end

    # Return true if the model exists (in some state) on the server.
    #
    # @return [Boolean]
    def persisted?
      !!id
    end

    private

    attr_reader :resource_gateway
  end
end
