require File.expand_path('../openkvk/configuration', __FILE__)
require File.expand_path('../openkvk/api', __FILE__)

module OpenKVK
  extend Configuration
    
  class << self
    
    def search(keywords)
      numbers = API.search(keywords)
      numbers.size > 0 ? API.query("SELECT * FROM kvk WHERE kvk IN (#{numbers.join(", ")})") : []
    end
    
    def find(options={})
      if options.is_a?(String)
        options = {:conditions => ["bedrijfsnaam LIKE '%#{options}%'", "bedrijfsnaam LIKE '%#{options.to_s.upcase}%'", "bedrijfsnaam LIKE '%#{capitalize_and_format_each_word(options)}%'"], :match_condition => :any}
      end
      options = {:limit => 1000, :select => ["*"], :count => :all, :match_condition => :all}.merge(options)
      
      options[:limit] = 1 if options[:count] == :first
      result = API.query("SELECT #{options[:select].join(", ")} FROM kvk WHERE #{options[:conditions].join(options[:match_condition] == :any ? " OR " : " AND ")} LIMIT #{options[:limit]}")
      return result.first if options[:count] == :first
      result
    end
    
    def find_by_bedrijfsnaam(name, options={})
      # bedrijfsnaam is always a string, so we want to search for different formats of the string
      options = {:conditions => ["bedrijfsnaam LIKE '%#{name}%'", "bedrijfsnaam LIKE '%#{name.to_s.upcase}%'", "bedrijfsnaam LIKE '%#{capitalize_and_format_each_word(name)}%'"], :match_condition => :any}.merge(options)
      find(options)
    end
    
    %w{kvk kvks adres postcode plaats type website}.each do |field|      
      define_method("find_by_#{field}") do |value, options|
        options = {:conditions => ["#{field} ILIKE '%#{value}%'"]}.merge(options || {})
        find(options)
      end
    end

    private
    
    def capitalize_and_format_each_word(name)
      # capitalize each word
      name.gsub!(/\b('?[a-z])/) do |word| 
        $1.capitalize
      end

      # format B.V. and N.V.
      name.gsub!(/([b|n]\.?v\.?)$/) do |match|
        "#{match[0].to_s.upcase}.V."
      end
      name
    end
    
  end
  
end