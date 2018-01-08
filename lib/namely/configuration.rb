module Namely
  class Configuration

    # The http codes that should be retried if a request fails while returning
    # a page in paged results. Number of times to retry specified in {#retries}.
    # Defaults to an empty Array.
    #
    # @see #retries
    # @return [Array<Integer>] the http codes to retry for a failed request
    attr_reader :http_codes_to_retry

    # Specifies the http codes of failed GET requests encountered while paging
    # that should be retried.
    #
    # @param codes [Array<Integer>, Integer] http codes to retry
    def http_codes_to_retry=(codes)
      @http_codes_to_retry = Array(codes).map(&:to_int)
    end

    # Controls the number of times that a request for a page that failed while
    # returning paged results with one of the http codes listed in
    # {#http_codes_to_retry} will be retried before raising
    # an exception. 0 by default.
    #
    # @return [Integer] number of times to retry request.
    attr_accessor :retries

    def initialize
      @http_codes_to_retry = []
      @retries = 0
    end
  end

  # @return [Namely::Configuration] Namely's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set Namely's configuration
  # @param config [Namely::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify Namely's current configuration
  # @yieldparam [Namely::Configuration] config current Namely config
  # ```
  # Namely.configure do |config|
  #   config.retries = 3
  # end
  # ```
  def self.configure
    yield configuration
  end
end

