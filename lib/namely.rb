require "backports"
require "json"
require "ostruct"
require "rest_client"

require "namely/authenticator"
require "namely/exceptions"
require "namely/resource_gateway"
require "namely/collection"
require "namely/connection"

require "namely/version"

module Namely
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :limit
  end
end
