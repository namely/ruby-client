$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "namely"
require "vcr"
require "webmock/rspec"

TEST_ACCESS_TOKEN = "26e61d40dcb6a87aa3e9090e998fae92"
TEST_SITE_NAME = "sales14"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

def set_configuration!
  Namely.configure do |config|
    config.access_token = TEST_ACCESS_TOKEN
    config.site_name = TEST_SITE_NAME
  end
end

def unset_configuration!
  Namely.configuration = nil
end

set_configuration!
