require_relative "model"

module Namely
  class Collection
    def initialize(resource_gateway)
      @resource_gateway = resource_gateway
    end

    def all
      resource_gateway.json_index.map { |model| build(model) }
    end

    def exists?(id)
      resource_gateway.show_head(id)
      true
    rescue RestClient::ResourceNotFound
      false
    end

    def find(id)
      build(resource_gateway.json_show(id))
    rescue RestClient::ResourceNotFound
      raise NoSuchModelError, "Can't find any #{endpoint} with id \"#{id}\""
    end

    def create!(attributes)
      build(attributes).save!
    end

    def build(attributes)
      Model.new(resource_gateway, attributes)
    end

    def endpoint
      resource_gateway.endpoint
    end

    private

    attr_reader :resource_gateway
  end
end
