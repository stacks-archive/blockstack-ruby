require 'spec_helper'
require 'bitcoin'

describe Blockstack, :vcr => { :cassette_name => "blockstack", :record => :new_episodes }  do


	it "should test " do
	    expect(Blockstack.test).to eq("hi")
	end

  # it "should raise an error when name is reserved" do
	# 	expect {
  #     Openname.get("pmarca")
	# 	}.to raise_error(NameError)
	# end
end
