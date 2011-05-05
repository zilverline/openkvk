require File.expand_path('../spec_helper', __FILE__)

describe OpenKVK do
  
  describe ".find" do
    it "should find a company" do
      company = OpenKVK.find("Zilverline B.V.", :first)
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