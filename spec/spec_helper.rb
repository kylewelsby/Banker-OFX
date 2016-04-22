require 'coveralls'
Coveralls.wear!

require 'rspec'
require "ofx"

RSpec.configure do |config|
  config.order = :rand
  config.expect_with(:rspec) { |c| c.syntax = :should }

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

RSpec::Matchers.define :have_key do |key|
  match do |hash|
    hash.respond_to?(:keys) &&
    hash.keys.kind_of?(Array) &&
    hash.keys.include?(key)
  end
end
