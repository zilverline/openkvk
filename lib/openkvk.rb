require File.expand_path('../openkvk/configuration', __FILE__)
require File.expand_path('../openkvk/api', __FILE__)

module OpenKVK
  extend Configuration
    
  class << self
    def find(options={})
      if options.is_a?(String)
        options = {:conditions => ["bedrijfsnaam LIKE '%#{options}%'"]}
      end
      options = {:limit => 1000, :select => ["*"], :count => :all, :match_condition => :all}.merge(options)
      
      options[:limit] = 1 if options[:count] == :first
      result = API.query("SELECT #{options[:select].join(", ")} FROM kvk WHERE #{options[:conditions].join(options[:match_condition] == :any ? " OR " : " AND ")} LIMIT #{options[:limit]}")
      return result.first if options[:count] == :first
      result
    end
    
    %w{kvk bedrijfsnaam kvks adres postcode plaats type website}.each do |field|      
      define_method("find_by_#{field}") do |value, options={}|
        options = {:conditions => ["#{field} LIKE '%#{value}%'"]}.merge(options)
        find(options)
      end
    end
    
  end
  

  
end
