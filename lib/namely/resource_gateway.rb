module Namely
  class ResourceGateway
    attr_reader :endpoint

    def initialize(options)
      @access_token = options.fetch(:access_token)
      @endpoint = options.fetch(:endpoint)
      @subdomain = options.fetch(:subdomain)
      @paged = options.fetch(:paged, false)
    end

    def json_index
      paged ? json_index_paged : json_index_all
    end

    def json_find_from(id, find_from)
      get("/#{endpoint}/#{id}/#{find_from}")[find_from]
    end

    def json_show(id)
      get("/#{endpoint}/#{id}")[resource_name].first
    end

    def show_head(id)
      head("/#{endpoint}/#{id}")
    end

    def create(attributes)
      response = post(
        "/#{endpoint}",
        endpoint => [attributes]
      )
      extract_id(response)
    end

    def update(id, changes)
      put("/#{endpoint}/#{id}", endpoint => [changes])
    end

    private

    def json_index_all
      get("/#{endpoint}", limit: :all)[resource_name]
    end

    def json_index_paged
      last_id = nil
      Enumerator.new do |y|
        params = {}

        loop do
          objects = with_retry { get("/#{endpoint}", params)[resource_name] }
          break if objects.empty?
          break if last_id == objects.last['id']

          objects.each { |o| y << o }
          last_id = objects.last['id']

          params[:after] = last_id
        end
      end
    end

    attr_reader :access_token, :subdomain, :paged

    def resource_name
      endpoint.split("/").last
    end

    def url(path)
      "https://#{subdomain}.namely.com/api/v1#{path}"
    end

    def extract_id(response)
      JSON.parse(response)[endpoint].first['id']
    rescue StandardError => e
      raise(
        FailedRequestError,
        "Couldn't parse \"id\" from response: #{e.message}"
      )
    end

    def with_retry
      retries ||= 0
      yield
    rescue RestClient::Exception => e
      raise unless Namely.configuration.http_codes_to_retry.include?(e.http_code)

      retry if (retries += 1) < Namely.configuration.retries
      raise
    end

    def get(path, params = {})
      JSON.parse(RestClient.get(url(path), accept: :json, params: params, authorization: "Bearer #{access_token}"))
    end

    def head(path, params = {})
      RestClient.head(url(path), accept: :json, params: params, authorization: "Bearer #{access_token}")
    end

    def post(path, params)
      RestClient.post(
        url(path),
        params.to_json,
        accept: :json,
        content_type: :json,
        authorization: "Bearer #{access_token}"
      )
    end

    def put(path, params)
      RestClient.put(
        url(path),
        params.to_json,
        accept: :json,
        content_type: :json,
        authorization: "Bearer #{access_token}"
      )
    end
  end
end
