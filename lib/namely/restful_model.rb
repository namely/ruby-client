module Namely
  class RestfulModel < OpenStruct
    def self.find(id)
      new(resource_gateway.json_show(endpoint, resource_name, id))
    rescue RestClient::ResourceNotFound
      raise NoSuchModelError, "Can't find a #{name} with id \"#{id}\""
    end

    def self.exists?(id)
      resource_gateway.show_head(endpoint, id)
      true
    rescue RestClient::ResourceNotFound
      false
    end

    def self.all
      resource_gateway.json_index(endpoint, resource_name).map { |model| new(model) }
    end

    private

    def self.resource_gateway
      Namely.resource_gateway
    end
  end
end
