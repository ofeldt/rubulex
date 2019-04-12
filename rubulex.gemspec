# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubulex/version'

Gem::Specification.new do |spec|
  spec.name          = "rubulex"
  spec.version       = Rubulex::VERSION
  spec.authors       = ["Oliver Feldt"]
  spec.email         = ["oliver.feldt@googlemail.com"]
  spec.description   = "A simple self-hosted Rubular Clone"
  spec.summary       = "Rubulex is a simple web application for developing/testing Regular Expression"
  spec.homepage      = "https://github.com/ofeldt/rubulex"
  spec.license       = "MIT"

  spec.add_runtime_dependency "sinatra",         "~> 2.0"
  spec.add_runtime_dependency "sinatra-contrib", "~> 2.0"
  spec.add_runtime_dependency "slim",            "~> 4.0"
  spec.add_runtime_dependency "sassc",           "~> 2.0"

  spec.add_development_dependency "rspec", "~> 3.8.0"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
