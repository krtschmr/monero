# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpc/version'

Gem::Specification.new do |spec|
  spec.name          = "monero"
  spec.version       = RPC::VERSION
  spec.authors       = ["Tim Kretschmer"]
  spec.email         = ["tim@krtschmr.de"]
  spec.description   = %q{A Monero-Wallet-RPC ruby client}
  spec.summary       = %q{A Monero-Wallet-RPC ruby client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'sqlite3'

  spec.required_rubygems_version = '>= 1.3.6'

  spec.add_dependency "money"
end
