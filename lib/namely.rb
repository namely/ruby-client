require "namely/client"
require "namely/improperly_configured_error"
require "namely/version"

module Namely
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration || raise(
      ImproperlyConfiguredError,
      "Before using the Namely gem, you'll need to configure it with `Namely.configure`."
    )
  end

  def self.configure
    @configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_writer :access_token, :site_name

    def access_token
      @access_token || raise_missing_variable_error(:access_token)
    end

    def site_name
      @site_name || raise_missing_variable_error(:site_name)
    end

    private

    def raise_missing_variable_error(variable)
      raise(
        ImproperlyConfiguredError,
        "The Namely `#{variable}` configuration variable hasn't been set... did you set it when you called `Namely.configure`?"
      )
    end
  end
end
