# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/cop_helper"
require "rubocop-avoid_unless"

RSpec.configure do |config|
  config.include CopHelper
  config.include RuboCop::RSpec::ExpectOffense
end
