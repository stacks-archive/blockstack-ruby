require 'spec_helper'

describe Onename, :vcr => { :cassette_name => "onename" }  do
 
  
  it "should have a default endpoint" do
    Onename.endpoint.should == "https://www.onename.io"
  end
  
  it "should allow setting a different endpoint and returning to default" do
    Onename.endpoint = "https://www.example.com"
    Onename.endpoint.should == "https://www.example.com"
    Onename.endpoint = nil
    Onename.endpoint.should == "https://www.onename.io"
  end
  
  it "should retrieve onename user" do 
    user = Onename.get("larry")
    user.is_a?(Onename::User).should == true
  end
    
    context "we've retrieved a onename user" do 
      before :each do 
        @user = Onename.get("larry")
      end
      
      it "should have a onename" do 
        @user.onename.should == "larry"
      end
      
    end
end
