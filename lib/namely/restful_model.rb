module Namely
  class RestfulModel < OpenStruct
    def self.find(id)
      new(json_show(id))
    rescue RestClient::ResourceNotFound
      raise NoSuchModelError, "Can't find a #{name} with id \"#{id}\""
    end

    def self.exists?(id)
      find(id)
      true
    rescue NoSuchModelError
      false
    end

    def self.all
      json_index.map { |model| new(model) }
    end

    private

    def self.url(path)
      "https://#{Namely.configuration.site_name}.namely.com/api/v1#{path}"
    end

    def self.json_index
      get("/#{endpoint}", limit: :all)[endpoint]
    end

    def self.json_show(id)
      get("/#{endpoint}/#{id}")[endpoint].first
    end

    def self.get(path, params = {})
      params.merge!(access_token: Namely.configuration.access_token)
      JSON.parse(RestClient.get(url(path), accept: :json, params: params))
    end
  end
end
