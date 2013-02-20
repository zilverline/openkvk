require 'rspec'

if (RUBY_VERSION || VERSION)[0..2] == "1.9"
  require 'simplecov'
  SimpleCov.start do
    add_group 'OpenKVK', 'lib/openkvk'
    add_group 'Specs', 'spec'
    add_filter __FILE__
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
end

def expect_query(sql, response)
  OpenKVK::API.expects(:get).with(sql).returns(response)
end

def expect_search(keywords, response)
  OpenKVK::API.expects(:get).with(keywords, "sphinx").returns(response)
end

load File.expand_path('../../lib/openkvk.rb', __FILE__)