module Namely
  class RestfulModel < OpenStruct
    def self.find(id)
      new(client.json_show(endpoint, id))
    rescue RestClient::ResourceNotFound
      raise NoSuchModelError, "Can't find a #{name} with id \"#{id}\""
    end

    def self.exists?(id)
      client.show_head(endpoint, id)
      true
    rescue RestClient::ResourceNotFound
      false
    end

    def self.all
      client.json_index(endpoint).map { |model| new(model) }
    end

    private

    def self.client
      Namely.client
    end
  end
end
