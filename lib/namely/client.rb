module Namely
  class Client
    def initialize(access_token, site_name)
      @access_token = access_token
      @site_name = site_name
    end

    def json_index(endpoint)
      get("/#{endpoint}", limit: :all)[endpoint]
    end

    def json_show(endpoint, id)
      get("/#{endpoint}/#{id}")[endpoint].first
    end

    def show_head(endpoint, id)
      head("/#{endpoint}/#{id}")
    end

    private

    attr_reader :access_token, :site_name

    def url(path)
      "https://#{site_name}.namely.com/api/v1#{path}"
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
