# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "namely/version"

Gem::Specification.new do |spec|
  spec.name          = "namely"
  spec.version       = Namely::VERSION
  spec.authors       = ["Namely"]
  spec.email         = ["integrations-dev@namely.com"]
  spec.summary       = "Wraps the Namely HTTP API in lovely Ruby."
  spec.homepage      = "https://github.com/namely/ruby-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "yard"
end
