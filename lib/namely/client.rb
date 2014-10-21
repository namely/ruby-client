require "json"
require "rest_client"

module Namely
  class Client
    def initialize(options)
      @access_token = options.fetch(:access_token)
      @site_name = options.fetch(:site_name)
    end

    def profiles
      JSON.parse(get("/profiles"))
    end

    private

    attr_reader :access_token, :site_name

    def get(path)
      RestClient.get(
        "https://#{site_name}.namely.com/api/v1#{path}",
        accept: :json,
        params: {access_token: access_token}
      )
    end
  end
end
