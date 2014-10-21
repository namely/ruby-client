require "namely/client"
require "namely/version"

module Namely
  class << self
    attr_accessor :configuration
  end

  def self.configure
    @configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :access_token, :site_name
  end
end
