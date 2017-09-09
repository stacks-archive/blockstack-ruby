require 'spec_helper'
require 'bitcoin'

describe Blockstack::User do
	larry_json_profile = {"@type"=>"Person", "account"=>[{"@type"=>"Account", "identifier"=>"larrysalibra", "proofType"=>"http", "service"=>"twitter"}, {"@type"=>"Account", "identifier"=>"larrysalibra", "proofType"=>"http", "service"=>"github"}, {"@type"=>"Account", "identifier"=>"1EyuZ8qxdhHjcnTChwQLyQaN3cmdK55DkH", "role"=>"payment", "service"=>"bitcoin"}, {"@type"=>"Account", "contentUrl"=>"http://pgp.mit.edu/pks/lookup?op=get&search=0xDE3B5425164C4849", "identifier"=>"B516CB7A08819697B25E4694DE3B5425164C4849", "role"=>"key", "service"=>"pgp"}, {"@type"=>"Account", "identifier"=>"larry.salibra", "proofType"=>"http", "proofUrl"=>"https://www.facebook.com/larry.salibra/posts/10100341028448093", "service"=>"facebook"}], "address"=>{"@type"=>"PostalAddress", "addressLocality"=>"Hong Kong"}, "description"=>"Blockchain, software, security. Decentralize the world (w/ #bitcoin)! 識中文", "image"=>[{"@type"=>"ImageObject", "contentUrl"=>"https://s3.amazonaws.com/kd4/larry", "name"=>"avatar"}, {"@type"=>"ImageObject", "contentUrl"=>"https://s3.amazonaws.com/dx3/larry", "name"=>"cover"}], "name"=>"Larry Salibra", "website"=>[{"@type"=>"WebSite", "url"=>"https://www.larrysalibra.com"}]}

	fredwilson_legacy_json_profile = JSON.parse <<-eos
	{
    "graph": {
      "url": "https://s3.amazonaws.com/grph/fredwilson"
    },
    "website": "http://avc.com",
    "location": {
      "formatted": "New York City"
    },
    "avatar": {
      "url": "https://s3.amazonaws.com/kd4/fredwilson1"
    },
    "twitter": {
      "username": "fredwilson",
      "proof": {
        "url": "https://twitter.com/fredwilson/status/533040726146162689"
      }
    },
    "bio": "I am a VC",
    "name": {
      "formatted": "Fred Wilson"
    },
    "cover": {
      "url": "https://s3.amazonaws.com/dx3/fredwilson"
    },
    "v": "0.2",
    "bitcoin": {
      "address": "1Fbi3WDPEK6FxKppCXReCPFTgr9KhWhNB7"
    },
    "facebook": {
      "username": "fred.wilson.963871",
      "proof": {
        "url": "https://facebook.com/fred.wilson.963871/posts/10100401430876108"
      }
    }
  }
	eos
	context "Creating user from profile json" do

		it "should load a current user profile" do
			user = Blockstack::User.from_json(larry_json_profile, "larry")
			expect(user.username).to eq("larry")
			expect(user.cover_url).to eq("https://s3.amazonaws.com/dx3/larry")
			expect(user.avatar_url).to eq("https://s3.amazonaws.com/kd4/larry")
			expect(user.location_formatted).to eq("Hong Kong")
			expect(user.bio).to eq("Blockchain, software, security. Decentralize the world (w/ #bitcoin)! 識中文")
			expect(user.website).to eq("https://www.larrysalibra.com")
			expect(user.angellist_username).to eq(nil)
			expect(user.github_username).to eq("larrysalibra")
			expect(user.facebook_username).to eq("larry.salibra")
			expect(user.twitter_username).to eq("larrysalibra")
			expect(user.instagram_username).to eq(nil)
			expect(user.linkedin_url).to eq(nil)
			expect(user.bitcoin_address).to eq("1EyuZ8qxdhHjcnTChwQLyQaN3cmdK55DkH")
			expect(user.bitmessage_address).to eq(nil)
			expect(user.bitcoinotc_username).to eq(nil)
			expect(user.pgp_fingerprint).to eq("B516CB7A08819697B25E4694DE3B5425164C4849")
			expect(user.pgp_url).to eq("http://pgp.mit.edu/pks/lookup?op=get&search=0xDE3B5425164C4849")
		end

		it "should load a legacy user " do
			user = Blockstack::User.from_json(fredwilson_legacy_json_profile, "fredwilson")
			expect(user.username).to eq("fredwilson")
			expect(user.avatar_url).to eq("https://s3.amazonaws.com/kd4/fredwilson1")
			expect(user.location_formatted).to eq("New York City")
			expect(user.bio).to eq("I am a VC")
			expect(user.website).to eq("http://avc.com")
			expect(user.angellist_username).to eq(nil)
			expect(user.github_username).to eq(nil)
			expect(user.facebook_username).to eq("fred.wilson.963871")
			expect(user.twitter_username).to eq("fredwilson")
			expect(user.instagram_username).to eq(nil)
			expect(user.linkedin_url).to eq(nil)
			expect(user.bitcoin_address).to eq("1Fbi3WDPEK6FxKppCXReCPFTgr9KhWhNB7")
			expect(user.bitmessage_address).to eq(nil)
			expect(user.bitcoinotc_username).to eq(nil)
			expect(user.pgp_fingerprint).to eq(nil)
			expect(user.pgp_url).to eq(nil)
		end

	end

end
