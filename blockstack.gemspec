# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blockstack/version'

Gem::Specification.new do |spec|
  spec.name          = "blockstack"
  spec.version       = Blockstack::VERSION
  spec.authors       = ["Larry Salibra"]
  spec.email         = ["rubygems@larrysalibra.com"]
  spec.summary       = "The Blockstack ruby library for identity and authentication"
  spec.homepage      = "https://github.com/larrysalibra/blockstack-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"

  spec.add_dependency "jwtb", "2.0.0.beta2.bsk1"
  spec.add_dependency "bitcoin-ruby"
  spec.add_dependency "faraday"

end
