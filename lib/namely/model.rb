require "ostruct"

module Namely
  class Model < OpenStruct
    def initialize(resource_gateway, attributes)
      @resource_gateway = resource_gateway
      super(attributes)
    end

    def save!
      if persisted?
        update(to_h)
      else
        self.id = resource_gateway.create(to_h)
      end
      self
    rescue RestClient::Exception => e
      raise FailedRequestError, e.message
    end

    def persisted?
      !!id
    end

    private

    attr_reader :resource_gateway
  end
end
