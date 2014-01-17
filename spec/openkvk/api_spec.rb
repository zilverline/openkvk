require 'uri'
require 'net/http'
require File.expand_path('../../spec_helper', __FILE__)

describe OpenKVK do

  describe ".get" do
    it "should return an array with records" do
      response = Hashie::Mash.new(:body => '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["342838240000","Zilverline Beheer B.V.","34283824","0","Finsenstraat 56","1098RJ","Amsterdam","Hoofdvestiging",null],["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')
      Net::HTTP.stubs(:get_response).returns(response)

      OpenKVK::API.query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' LIMIT 99").size.should == 2
    end

    it "should follow a redirect" do
      response = Hashie::Mash.new(:Location => "new location", :body => '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["342838240000","Zilverline Beheer B.V.","34283824","0","Finsenstraat 56","1098RJ","Amsterdam","Hoofdvestiging",null],["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')

      response.stubs(:kind_of?).returns(Net::HTTPRedirection)
      Net::HTTP.stubs(:get_response).returns(response)

      OpenKVK::API.query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' LIMIT 99").size.should == 2
    end

    it "should raise an exception when something goes wrong" do
      Net::HTTP.stubs(:get_response).raises(Exception.new("test exception"))
      lambda {
        OpenKVK::API.query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' LIMIT 99")
      }.should raise_error OpenKVK::InvalidResponseException
    end

    it "should raise an exception when an blank result is returned by the host" do
      response = stub(:body => "")
      response.stubs(:kind_of?).returns(false)
      Net::HTTP.stubs(:get_response).returns(response)

      lambda {
        OpenKVK::API.search("zilverline")
      }.should raise_error OpenKVK::InvalidResponseException
    end

  end

end