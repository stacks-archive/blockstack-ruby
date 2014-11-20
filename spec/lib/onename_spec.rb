require 'spec_helper'

describe Openname, :vcr => { :cassette_name => "openname" }  do
 
  
  it "should have a default endpoint" do
    Openname.endpoint.should == "https://www.onename.io"
  end
  
  it "should allow setting a different endpoint and returning to default" do
    Openname.endpoint = "https://www.example.com"
    Openname.endpoint.should == "https://www.example.com"
    Openname.endpoint = nil
    Openname.endpoint.should == "https://www.onename.io"
  end
  
  it "should retrieve openname user" do 
    user = Openname.get("larry")
    user.is_a?(Openname::User).should == true
  end
    
    context "we've retrieved an openname user" do 
      before :each do 
        @user = Openname.get("larry")
      end
      
      it "should have a openname" do 
        @user.openname.should == "larry"
      end
      
    end
end
