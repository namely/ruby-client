# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "namely/version"

Gem::Specification.new do |spec|
  spec.name          = "namely"
  spec.version       = Namely::VERSION
  spec.authors       = ["Harry Schwartz"]
  spec.email         = ["harry@thoughtbot.com"]
  spec.summary       = "Wraps the Namely HTTP API in lovely Ruby."
  spec.homepage      = "https://github.com/namely/ruby-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest_client"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
