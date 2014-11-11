require_relative "model"

module Namely
  class Collection
    def initialize(resource_gateway)
      @resource_gateway = resource_gateway
    end

    # Return every instance of this model.
    #
    # A model might have quite a few instances. If this is the case,
    # the query may take some time (several seconds) and the resulting
    # array may be very large.
    #
    # @return [Array<Model>]
    def all
      resource_gateway.json_index.map { |model| build(model) }
    end

    # Instantiate (but don't save) a new Model with the given attributes.
    #
    # @param [Hash] attributes the attributes of the model being built.
    #
    # @return [Model]
    def build(attributes)
      Model.new(resource_gateway, attributes)
    end

    # Create a new Model on the server with the given attributes.
    #
    # @param [Hash] attributes the attributes of the model being created.
    #
    # @example
    #   profiles_collection.create!(
    #     first_name: "Beardsly",
    #     last_name: "McDog",
    #     email: "beardsly@namely.com"
    #   )
    #
    # @return [Model] the created model.
    def create!(attributes)
      build(attributes).save!
    end

    def endpoint
      resource_gateway.endpoint
    end

    # Returns true if a Model with this ID exists, false otherwise.
    #
    # @param [#to_s] id
    #
    # @return [Boolean]
    def exists?(id)
      resource_gateway.show_head(id)
      true
    rescue RestClient::ResourceNotFound
      false
    end

    # Fetch a model from the server by its ID.
    #
    # @param [#to_s] id
    #
    # @raise [NoSuchModelError] if the model wasn't found.
    #
    # @return [Model]
    def find(id)
      build(resource_gateway.json_show(id))
    rescue RestClient::ResourceNotFound
      raise NoSuchModelError, "Can't find any #{endpoint} with id \"#{id}\""
    end

    private

    attr_reader :resource_gateway
  end
end
