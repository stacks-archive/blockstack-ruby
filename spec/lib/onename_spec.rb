require 'spec_helper'
require 'bitcoin'

describe Openname, :vcr => { :cassette_name => "openname", :record => :new_episodes }  do


	it "should have a default endpoint" do
	    Openname.endpoint.should == "https://openname.nametiles.co/v2/"
	end

	it "should allow setting a different endpoint and returning to default" do
		Openname.endpoint = "https://www.example.com"
		Openname.endpoint.should == "https://www.example.com"
	    Openname.endpoint = nil
	    Openname.endpoint.should == "https://api.nametiles.co/v1/users"
	  end

	it "should retrieve openname user" do
	    user = Openname.get("larry")
	    user.is_a?(Openname::User).should == true
	end

	it "should give error if openname user does not exist" do
	    expect {
		    user = Openname.get("nothere")
		}.to raise_error(NameError)
	end

    context "we've retrieved an openname user" do
      before :each do
        @user = Openname.get("larry")
      end

      it "should have a openname" do
        @user.openname.should == "larry"
      end

      it "should have a bitcoin address" do
	    address = @user.bitcoin_address
	    Bitcoin.valid_address?(address).should == true
	  end

    end

    context "retrieving Bitcoin addreses" do
	    it "should retrieve a Bitcoin address" do
		    address = Openname.get_bitcoin_address("larry")
		    Bitcoin.valid_address?(address).should == true

		    address = Openname.get_bitcoin_address("143xFrxppUD9oQE7mGvQFe23h814YorMBs")
		    Bitcoin.valid_address?(address).should == true
		end

		it "should raise an error when retrieving poorly formed Bitcoin address" do
			expect {
				address = Openname.get_bitcoin_address("143xFrxpp")
			}.to raise_error(ArgumentError)

		end

		it "should raise an error when user has no Bitcoin address" do
			expect {
				address = Openname.get_bitcoin_address("bitcoinhater")
			}.to raise_error(NameError)

		end

    it "should raise an error when name is reserved" do
			expect {
        Openname.get("pmarca")
			}.to raise_error(NameError)

		end
	end
end
