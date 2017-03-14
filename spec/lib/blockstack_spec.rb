require 'spec_helper'
require 'bitcoin'

describe Blockstack, :vcr => { :cassette_name => "blockstack", :record => :new_episodes }  do

	context "getting did types" do

		it "should get did type from did" do
			decentralized_id = "did:btc-addr:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx"
			expect(Blockstack.get_did_type(decentralized_id)).to eq("btc-addr")
		end

		it "should raise RuntimeError if there aren't 3 parts" do
			decentralized_id = "did:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx"
			expect {
		       Blockstack.get_did_type(decentralized_id)
				}.to raise_error(RuntimeError)
		end

		it "should raise RuntimeError if it doesn't start with did" do
			decentralized_id = "btc-addr:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx"
			expect {
					 Blockstack.get_did_type(decentralized_id)
				}.to raise_error(RuntimeError)
		end

	end

	context "extracting bitcoin address from did" do
		
		it "should return bitcoin address given valid did" do
			decentralized_id = "did:btc-addr:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx"
			expect(Blockstack.get_address_from_did(decentralized_id)).to eq("1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx")
		end

	end

end
