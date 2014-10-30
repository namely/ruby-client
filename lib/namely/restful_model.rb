module Namely
  # @abstract
  class RestfulModel < OpenStruct
    # Fetch a model from the server by its ID.
    #
    # @param [#to_s] id
    #
    # @raise [NoSuchModelError] if the model wasn't found.
    #
    # @return [RestfulModel]
    def self.find(id)
      new(resource_gateway.json_show(id))
    rescue RestClient::ResourceNotFound
      raise NoSuchModelError, "Can't find a #{name} with id \"#{id}\""
    end

    # Returns true if a model with this ID exists, false otherwise.
    #
    # @param [#to_s] id
    #
    # @return [Boolean]
    def self.exists?(id)
      resource_gateway.show_head(id)
      true
    rescue RestClient::ResourceNotFound
      false
    end

    # Return every instance of this model.
    #
    # A model might have quite a few instances. If this is the case,
    # the query may take some time (several seconds) and the resulting
    # array may be very large.
    #
    # @return [Array<RestfulModel>]
    def self.all
      resource_gateway.json_index.map { |model| new(model) }
    end

    # Create a new model on the server with the given attributes.
    #
    # @param [Hash] attributes the attributes of the model being created.
    #
    # @example
    #   Profile.create!(
    #     first_name: "Beardsly",
    #     last_name: "McDog",
    #     email: "beardsly@namely.com"
    #   )
    #
    # @return [RestfulModel] the created model.
    def self.create!(attributes)
      new(attributes).save!
    end

    # Try to persist the current (unpersisted) object. Raise an error
    # if the object can't be saved.
    #
    # @raise [FailedRequestError] if the request failed for any reason.
    #
    # @return [RestfulModel] the model itself, if saving succeeded.
    def save!
      if !persisted?
        self.id = resource_gateway.create(to_h)
        self
      end
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

    def self.resource_gateway
      Namely.resource_gateway(resource_name, endpoint)
    end

    def resource_gateway
      self.class.resource_gateway
    end

    def self.endpoint
      raise(
        NotImplementedError,
        "Namely::Model subclasses must define an `.endpoint` "\
        "class method that returns their path in the API."
      )
    end

    def self.resource_name
      endpoint.split("/").last
    end
  end
end
