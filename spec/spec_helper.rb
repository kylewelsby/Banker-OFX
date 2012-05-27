unless ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec'
  end
end

require 'rspec'
require "ofx"

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true

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
