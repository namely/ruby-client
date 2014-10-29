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

    private

    def self.resource_gateway
      Namely.resource_gateway(resource_name, endpoint)
    end

    def self.resource_name
      endpoint.split("/").last
    end
  end
end
