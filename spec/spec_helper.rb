$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "namely"
require "vcr"
require "webmock/rspec"

TEST_ACCESS_TOKEN = "26e61d40dcb6a87aa3e9090e998fae92"
TEST_SITE_NAME = "sales14"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
end
