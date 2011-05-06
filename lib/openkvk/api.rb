require 'uri'
require 'net/http'
require 'json'
require 'hashie/mash'

module OpenKVK
  class InvalidResponseException < Exception; end
  
  class API
    class << self
      def query(query)
        #puts query
        result = JSON.parse(get(query)).first["RESULT"]

        records = []
        result["ROWS"].each do |row|
          records << Hashie::Mash.new(Hash[*result["HEADER"].zip(row).flatten])
        end
        records
      end
      
      private
      
      def get(query)
        begin
          response = Net::HTTP.get_response(URI.parse("#{OpenKVK.host}json/#{URI.escape(query)}"))
          if response.kind_of?(Net::HTTPRedirection)
            response = Net::HTTP.get_response(URI.parse("#{OpenKVK.host}#{URI.escape(response["Location"])}"))
          end
          response.body
        rescue Exception => e
          raise InvalidResponseException.new("Couldn't get the response: #{$!}")
        end
      end

    end
  end
end