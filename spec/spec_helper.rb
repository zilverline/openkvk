require 'rspec'
require 'simplecov'
SimpleCov.start do
  add_group 'OpenKVK', 'lib/openkvk'
  add_group 'Specs', 'spec'
  add_filter __FILE__
end

RSpec.configure do |config|
  config.mock_with :mocha
end

def response(data)
  response = Hashie::Mash.new(:body => data)
  Net::HTTP.stubs(:get_response).returns(response)
end

load File.expand_path('../../lib/openkvk.rb', __FILE__)