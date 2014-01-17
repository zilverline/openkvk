require File.expand_path('../openkvk/configuration', __FILE__)
require File.expand_path('../openkvk/api', __FILE__)

module OpenKVK
  extend Configuration

  class << self

    def search(keywords)
      results = API.search(keywords)
      numbers = results.collect{|result| result.kvk}
      numbers.size > 0 ? API.query("SELECT * FROM kvk WHERE kvk IN (#{numbers.join(", ")})") : []
    end

    def find(options={})
      if options.is_a?(String)
        options = {:conditions => ["bedrijfsnaam ILIKE '%#{options}%'"], :match_condition => :any}
      end
      options = {:limit => 99, :select => ["*"], :count => :all, :match_condition => :all}.merge(options)

      options[:limit] = 1 if options[:count] == :first
      result = API.query("SELECT #{options[:select].join(", ")} FROM kvk WHERE #{options[:conditions].join(options[:match_condition] == :any ? " OR " : " AND ")} LIMIT #{options[:limit]}")
      return result.first if options[:count] == :first
      result
    end

    def find_by_kvk(kvk, options={})
      #kvk is not a string, so no like query...
      options = {:conditions => ["kvks = #{kvk}", "kvk = #{kvk}"], :match_condition => :any}.merge(options)
      find(options)
    end

    %w{adres bedrijfsnaam postcode plaats type website}.each do |field|
      define_method("find_by_#{field}") do |value, options={}|
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