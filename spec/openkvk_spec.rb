require File.expand_path('../spec_helper', __FILE__)

describe OpenKVK do
  
  describe ".find" do
    it "should find a company" do
      response('[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')

      company = OpenKVK.find("Zilverline", :first)
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.kvk.should == "343774520000"
      company.adres.should == "Molukkenstraat 200 E4"
      company.postcode.should == "1098TW"
      company.plaats.should == "Amsterdam"
      company.type.should == "Hoofdvestiging"
      company.website.should be nil
    end
    
    it "should find multiple companies" do
      response('[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["342838240000","Zilverline Beheer B.V.","34283824","0","Finsenstraat 56","1098RJ","Amsterdam","Hoofdvestiging",null],["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')
      
      companies = OpenKVK.find("Zilverline")
      companies.size.should == 2
      
      company = companies.last
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.kvk.should == "343774520000"
      company.adres.should == "Molukkenstraat 200 E4"
      company.postcode.should == "1098TW"
      company.plaats.should == "Amsterdam"
      company.type.should == "Hoofdvestiging"
      company.website.should be nil
    end
  end
  
  describe ".host=" do
    it "should set the host" do
      OpenKVK.host = "http://api.openkvk.nl/"
      OpenKVK.host.should == "http://api.openkvk.nl/"
    end
  end

  describe ".configure" do
    OpenKVK::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        OpenKVK.configure do |config|
          config.send("#{key}=", key)
          OpenKVK.send(key).should == key
        end
      end
    end
  end
  
end