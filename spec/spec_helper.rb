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
  config.filter_sensitive_data("<TEST_ACCESS_TOKEN>") { ENV.fetch("TEST_ACCESS_TOKEN") }
  config.filter_sensitive_data("<TEST_SUBDOMAIN>") { ENV.fetch("TEST_SUBDOMAIN") }
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
