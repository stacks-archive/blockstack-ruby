require 'spec_helper'
require 'bitcoin'

describe Blockstack, vcr: { cassette_name: 'blockstack', record: :new_episodes } do
	ENCODED_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksifQ.eyJqdGkiOiI0YmJlOGQ5NS03NzJmLTRjNDYtYTQ3Yi1mZjY4NDNjNTNjYWQiLCJpYXQiOjE0ODk1MTE1MzksImV4cCI6MTQ5MjE4OTkzOSwiaXNzIjoiZGlkOmJ0Yy1hZGRyOjFFWHdyejJFM1d2eGhkZVJCMUFyS3RkRTVOS3RLQzdFZHgiLCJwdWJsaWNLZXlzIjpbIjAzMTY1NTliZDBlNDk4ZGEzZjQyZjZiZjAzNGNiNWNjY2NlOTUzMmY2ZWIyNzYxMGE2OWIxNmExNTBmMjY4OTZlZiJdLCJwcm9maWxlIjp7IkB0eXBlIjoiUGVyc29uIiwiQGNvbnRleHQiOiJodHRwOi8vc2NoZW1hLm9yZyIsImdpdmVuTmFtZSI6ImhpIiwiZmFtaWx5TmFtZSI6Im9rIiwiaW1hZ2UiOlt7IkB0eXBlIjoiSW1hZ2VPYmplY3QiLCJuYW1lIjoiYXZhdGFyIiwiY29udGVudFVybCI6IiJ9LHsiQHR5cGUiOiJJbWFnZU9iamVjdCIsIm5hbWUiOiJhdmF0YXIiLCJjb250ZW50VXJsIjoiaHR0cHM6Ly93d3cuZHJvcGJveC5jb20vcy9jMGcyd2d5dWdkd3AydHovYXZhdGFyLTE_ZGw9MSJ9XX0sInVzZXJuYW1lIjoiZGV2bmFtZTIuaWQifQ.RUjwQcf8Irpjk9ZrcfoaQv7h-P8iBwmaf4TX5fqFJOHCUi2GrMth3R6J359cKtOujqHqUByQY6LWPEdMNY06CA'


	context "configuring api settings" do
		it "should have a default blockstack api url" do
			expect(Blockstack.api).to eq("https://core.blockstack.org")
		end

		it 'should change the blockstack api url and reset to default' do
			Blockstack.api = 'https://api.blockstack.org'
			expect(Blockstack.api).to eq('https://api.blockstack.org')
			Blockstack.api = nil
			expect(Blockstack.api).to eq("https://core.blockstack.org")
		end

		it 'should have a default leeway' do
			expect(Blockstack.leeway).to eq(30)
		end

		it 'should change the leeway and reset to default' do
			Blockstack.leeway = 888
			expect(Blockstack.leeway).to eq(888)
			Blockstack.leeway = nil
			expect(Blockstack.leeway).to eq(30)
		end

		it 'should have a default valid within time' do
			expect(Blockstack.valid_within).to eq(30)
		end

		it 'should change the valid within time and reset to default' do
			Blockstack.valid_within = 888
			expect(Blockstack.valid_within).to eq(888)
			Blockstack.valid_within = nil
			expect(Blockstack.valid_within).to eq(30)
		end
	end

	context 'getting did types' do
		it 'should get did type from did' do
			decentralized_id = 'did:btc-addr:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx'
			expect(Blockstack.get_did_type(decentralized_id)).to eq('btc-addr')
		end

		it "should raise RuntimeError if there aren't 3 parts" do
			decentralized_id = 'did:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx'
			expect {
	  		Blockstack.get_did_type(decentralized_id)
			}.to raise_error(RuntimeError)
		end

		it "should raise RuntimeError if it doesn't start with did" do
			decentralized_id = 'btc-addr:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx'
			expect {
				Blockstack.get_did_type(decentralized_id)
			}.to raise_error(RuntimeError)
		end
	end

	context 'extracting bitcoin address from did' do
		it 'should return bitcoin address given valid did' do
			decentralized_id = 'did:btc-addr:1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx'
			expect(Blockstack.get_address_from_did(decentralized_id)).to eq('1EXwrz2E3WvxhdeRB1ArKtdE5NKtKC7Edx')
		end
	end
end
