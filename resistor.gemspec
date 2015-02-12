# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resistor/version'

Gem::Specification.new do |spec|
  spec.name          = "resistor"
  spec.version       = Resistor::VERSION
  spec.authors       = ["seinosuke"]
  spec.email         = ["seinosuke.3606@gmail.com"]
  spec.summary       = %q{Resistor gem}
  spec.description   = %q{Resistor is a gem for the resistor unit.}
  spec.homepage      = "https://github.com/seinosuke/resistor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
end
