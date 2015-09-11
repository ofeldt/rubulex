# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubulex/version'

Gem::Specification.new do |gem|
  gem.name          = "rubulex"
  gem.version       = Rubulex::VERSION
  gem.authors       = ["Oliver Feldt"]
  gem.email         = ["oliver.feldt@googlemail.com"]
  gem.description   = "A simple self-hosted Rubular Clone"
  gem.summary       = "Rubulex is a simple web application for developing/testing Regular Expression"
  gem.homepage      = "https://github.com/ofeldt/rubulex"

  gem.add_runtime_dependency "sinatra", "~> 1.4.3"
  gem.add_runtime_dependency "sinatra-contrib", "~> 1.4.1"
  gem.add_runtime_dependency "slim",    "~> 2.0.1"
  gem.add_runtime_dependency "sass",    "~> 3.2.10"

  gem.add_development_dependency "rspec", "~> 2.14.1"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
