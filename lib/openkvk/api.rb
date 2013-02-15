require 'rubygems'
require 'uri'
require 'net/http'
require 'json'
require 'hashie/mash'

module OpenKVK
  class InvalidResponseException < Exception; end
  
  class API
    class << self
      def search(keywords)
        begin
          JSON.parse(get(keywords, "sphinx")).first["RESULT"]
        rescue Exception => e
          raise_exception
        end
      end
      
      def query(query)
        begin
          result = JSON.parse(get(query)).first["RESULT"]
          result["ROWS"].map { |row| Hashie::Mash.new(Hash[*result["HEADER"].zip(row).flatten]) }
        rescue Exception => e
          raise_exception
        end
      end
      
      private
      
      def get(query, service="api")
        response = Net::HTTP.get_response(URI.parse("http://#{service}.#{OpenKVK.host}/json/#{URI.escape(query)}"))
        if response.kind_of?(Net::HTTPRedirection)
          response = Net::HTTP.get_response(URI.parse("http://#{service}.#{OpenKVK.host}/#{URI.escape(response["Location"])}"))
        end
        response.body
      end

      def raise_exception
        raise InvalidResponseException.new("Couldn't get the response: #{$!}")
      end

    end
  end
end