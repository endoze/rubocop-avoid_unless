# frozen_string_literal: true

require_relative "lib/rubocop/avoid_unless/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-avoid_unless"
  spec.version = RuboCop::AvoidUnless::VERSION
  spec.authors = ["Endoze"]
  spec.summary = "RuboCop cop that disallows `unless` in favor of `if` with inverted conditions"
  spec.description = "A RuboCop extension that provides a Style/AvoidUnless cop. " \
    "It flags all uses of `unless` and auto-corrects them to `if` with " \
    "an inverse or negated condition."
  spec.homepage = "https://github.com/endoze/rubocop-avoid_unless"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*", "config/**/*", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rubocop", ">= 1.72"
  spec.add_dependency "lint_roller", "~> 1.1"
end
