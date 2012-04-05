require 'uri'
require 'net/http'
require 'json'
require 'hashie/mash'

module OpenKVK
  class InvalidResponseException < Exception; end
  
  class API
    class << self
      def search(keywords)
        JSON.parse(get(keywords, "sphinx")).first["RESULT"]
      end
      
      def query(query)
        result = JSON.parse(get(query)).first["RESULT"]
        result["ROWS"].map { |row| Hashie::Mash.new(Hash[*result["HEADER"].zip(row).flatten]) }
      end
      
      private
      
      def get(query, service="api")
        begin
          response = Net::HTTP.get_response(URI.parse("http://#{service}.#{OpenKVK.host}/json/#{URI.escape(query)}"))
          if response.kind_of?(Net::HTTPRedirection)
            response = Net::HTTP.get_response(URI.parse("http://#{service}.#{OpenKVK.host}/#{URI.escape(response["Location"])}"))
          end
          response.body
        rescue Exception => e
          raise InvalidResponseException.new("Couldn't get the response: #{$!}")
        end
      end

    end
  end
end