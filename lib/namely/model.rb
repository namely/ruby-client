require "ostruct"

module Namely
  class Model < OpenStruct
    def initialize(resource_gateway, attributes)
      @resource_gateway = resource_gateway
      super(attributes)
    end

    # Try to persist the current object to the server by creating a
    # new resource or updating an existing one. Raise an error if the
    # object can't be saved.
    #
    # @raise [FailedRequestError] if the request failed for any reason.
    #
    # @return [Model] the model itself, if saving succeeded.
    def save!
      if persisted?
        update(to_h)
      else
        self.id = resource_gateway.create(to_h)
      end
      self
    rescue RestClient::Exception => e
      raise_failed_request_error(e)
    end

    # Update the attributes of this model. Assign the attributes
    # according to the hash, then persist those changes on the server.
    #
    # @param [Hash] attributes the attributes to be updated on the model.
    #
    # @example
    #   my_profile.update(
    #     middle_name: "Ludwig"
    #   )
    #
    # @raise [FailedRequestError] if the request failed for any reason.
    #
    # @return [Model] the updated model.
    def update(attributes)
      attributes.each do |key, value|
        self[key] = value
      end

      begin
        resource_gateway.update(id, attributes)
      rescue RestClient::Exception => e
        raise_failed_request_error(e)
      end

      self
    end

    # Return true if the model exists (in some state) on the server.
    #
    # @return [Boolean]
    def persisted?
      id != nil
    end

    private

    def raise_failed_request_error(restclient_error)
      errors = JSON.parse(restclient_error.response)["errors"]
      if errors.nil?
        raise FailedRequestError, restclient_error.message
      else
        raise(
          FailedRequestError,
          "#{restclient_error.message}: #{errors.join(", ")}"
        )
      end
    end

    attr_reader :resource_gateway
  end
end
