module Namely
  class ResourceGateway
    def initialize(options)
      @access_token = options.fetch(:access_token)
      @endpoint = options.fetch(:endpoint)
      @resource_name = options.fetch(:resource_name)
      @subdomain = options.fetch(:subdomain)
    end

    def json_index
      get("/#{endpoint}", limit: :all)[resource_name]
    end

    def json_show(id)
      get("/#{endpoint}/#{id}")[resource_name].first
    end

    def show_head(id)
      head("/#{endpoint}/#{id}")
    end

    private

    attr_reader :access_token, :endpoint, :resource_name, :subdomain

    def url(path)
      "https://#{subdomain}.namely.com/api/v1#{path}"
    end

    def get(path, params = {})
      params.merge!(access_token: access_token)
      JSON.parse(RestClient.get(url(path), accept: :json, params: params))
    end

    def head(path, params = {})
      params.merge!(access_token: access_token)
      RestClient.head(url(path), accept: :json, params: params)
    end
  end
end
