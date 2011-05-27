require File.expand_path('../spec_helper', __FILE__)

describe OpenKVK do
  
  describe ".find" do
    it "should find a company" do
      expect_query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' LIMIT 1", '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')

      company = OpenKVK.find(:conditions => ["bedrijfsnaam LIKE '%Zilverline%'"], :count => :first)
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.kvk.should == "343774520000"
      company.adres.should == "Molukkenstraat 200 E4"
      company.postcode.should == "1098TW"
      company.plaats.should == "Amsterdam"
      company.type.should == "Hoofdvestiging"
      company.website.should be nil
    end
    
    it "should find multiple companies" do
      expect_query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' OR bedrijfsnaam LIKE '%ZILVERLINE%' OR bedrijfsnaam LIKE '%%' LIMIT 1000", '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["342838240000","Zilverline Beheer B.V.","34283824","0","Finsenstraat 56","1098RJ","Amsterdam","Hoofdvestiging",null],["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')
      
      companies = OpenKVK.find("Zilverline")
      companies.size.should == 2
      
      company = companies.last
      company.bedrijfsnaam.should == "Zilverline B.V."
    end
    
    it "should only return selected fields" do
      expect_query("SELECT bedrijfsnaam FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' LIMIT 1", '[{"RESULT":{"TYPES":["varchar"],"HEADER":["bedrijfsnaam"],"ROWS":[["Zilverline B.V."]]}}]')
      
      company = OpenKVK.find(:conditions => ["bedrijfsnaam LIKE '%Zilverline%'"], :count => :first, :select => [:bedrijfsnaam])
      
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.keys.should == %w{bedrijfsnaam}
      
      expect_query("SELECT bedrijfsnaam, kvk FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' LIMIT 1", '[{"RESULT":{"TYPES":["varchar","bigint"],"HEADER":["bedrijfsnaam","kvk"],"ROWS":[["Zilverline B.V.","343774520000"]]}}]')
      
      company = OpenKVK.find(:conditions => ["bedrijfsnaam LIKE '%Zilverline%'"], :count => :first, :select => [:bedrijfsnaam, :kvk])
      
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.kvk.should == "343774520000"
      company.keys.should == %w{bedrijfsnaam kvk}
    end
    
    it "should find a company with multiple conditions" do
      expect_query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline%' AND kvk = '343774520000' LIMIT 1", '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')

      company = OpenKVK.find(:conditions => ["bedrijfsnaam LIKE '%Zilverline%'", "kvk = '343774520000'"], :count => :first)
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.kvk.should == "343774520000"
    end
    
    it "should find a company with multiple conditions" do
      expect_query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%FooBar%' OR kvk = '343774520000' LIMIT 1", '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')

      company = OpenKVK.find(:conditions => ["bedrijfsnaam LIKE '%FooBar%'", "kvk = '343774520000'"], :match_condition => :any, :count => :first)
      company.bedrijfsnaam.should == "Zilverline B.V."
      company.kvk.should == "343774520000"
    end
  end
  

  describe ".find_by_bedrijfsnaam" do
    it "should find a company" do
      expect_query("SELECT * FROM kvk WHERE bedrijfsnaam LIKE '%Zilverline B.V.%' OR bedrijfsnaam LIKE '%ZILVERLINE B.V.%' OR bedrijfsnaam LIKE '%Zilverline B.V.%' LIMIT 1", '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')
    
      OpenKVK.find_by_bedrijfsnaam("Zilverline B.V.", :count => :first).bedrijfsnaam.should == "Zilverline B.V."
    end
  end
  
  describe ".find_by_kvk" do
    it "should find a company" do
      expect_query("SELECT * FROM kvk WHERE kvk ILIKE '%343774520000%' LIMIT 1", '[{"RESULT":{"TYPES":["bigint","varchar","int","int","varchar","varchar","varchar","varchar","varchar"],"HEADER":["kvk","bedrijfsnaam","kvks","sub","adres","postcode","plaats","type","website"],"ROWS":[["343774520000","Zilverline B.V.","34377452","0","Molukkenstraat 200 E4","1098TW","Amsterdam","Hoofdvestiging",null]]}}]')
    
      OpenKVK.find_by_kvk("343774520000", :count => :first).bedrijfsnaam.should == "Zilverline B.V."
    end
  end
  
  describe ".host=" do
    it "should set the host" do
      OpenKVK.host = "http://api.openkvk.nl/"
      OpenKVK.host.should == "http://api.openkvk.nl/"
    end
  end
  
  describe ".options" do
    it "should return a hash with the current settings" do
      OpenKVK.host = "test host"
      OpenKVK.options == {:host => "test host"}
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