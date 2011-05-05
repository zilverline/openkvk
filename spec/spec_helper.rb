require 'rspec'
require 'simplecov'
SimpleCov.start do
  add_group 'OpenKVK', 'lib/openkvk'
  add_group 'Specs', 'spec'
  add_filter __FILE__
end

RSpec.configure do |config|
  config.mock_with :mocha

  config.before(:each) do
    # mock connection
  end
end

load File.expand_path('../../lib/openkvk.rb', __FILE__)