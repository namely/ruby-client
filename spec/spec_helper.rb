$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

Dir[File.join(File.dirname(__FILE__), "shared_examples", "*")].each { |f| require f }

require "namely"
require "dotenv"
require "vcr"
require "webmock/rspec"

Dotenv.load

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock

  environment_variables = [
    "AUTH_CODE",
    "CLIENT_ID",
    "CLIENT_REDIRECT_URI",
    "CLIENT_SECRET",
    "TEST_ACCESS_TOKEN",
    "TEST_REFRESH_TOKEN",
    "TEST_SUBDOMAIN",
  ]

  environment_variables.each do |env_var|
    config.filter_sensitive_data("<#{env_var}>") do
      ENV.fetch(env_var)
    end
  end
end

def classname
  described_class.name.split("::").last.downcase
end

def set_configuration!
  Namely.configure do |config|
    config.access_token = ENV.fetch("TEST_ACCESS_TOKEN")
    config.subdomain = ENV.fetch("TEST_SUBDOMAIN")
  end
end

def unset_configuration!
  Namely.configuration = nil
end

set_configuration!
