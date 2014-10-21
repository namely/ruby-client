require "json"
require "rest_client"

module Namely
  class Client
    def profiles
      JSON.parse(get("/profiles"))
    end

    private

    def get(path)
      RestClient.get(
        "https://#{Namely.configuration.site_name}.namely.com/api/v1#{path}",
        accept: :json,
        params: {access_token: Namely.configuration.access_token}
      )
    end
  end
end
