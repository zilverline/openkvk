require File.expand_path('../openkvk/configuration', __FILE__)
require File.expand_path('../openkvk/api', __FILE__)

module OpenKVK
  extend Configuration
  
  class << self
    def find(name, count=:all, options={})
      options = {:limit => 1000}.merge(options)
      options[:limit] = 1 if count == :first
      result = API.query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%#{name}%' LIMIT #{options[:limit]}")
      return result.first if count == :first
      result
    end
  end
  
end
