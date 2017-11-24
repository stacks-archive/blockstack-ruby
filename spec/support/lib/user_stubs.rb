RSpec.shared_examples 'user_stubs', user_stubs: true do
  let(:larry_json_profile) do
    {
      "@type"=>"Person",
      "account"=>
        [{"@type"=>"Account",
          "identifier"=>"larrysalibra",
          "proofType"=>"http",
          "service"=>"twitter"},
         {"@type"=>"Account",
          "identifier"=>"larrysalibra",
          "proofType"=>"http",
          "service"=>"github"},
         {"@type"=>"Account",
          "identifier"=>"1EyuZ8qxdhHjcnTChwQLyQaN3cmdK55DkH",
          "role"=>"payment",
          "service"=>"bitcoin"},
         {"@type"=>"Account",
          "contentUrl"=>
           "http://pgp.mit.edu/pks/lookup?op=get&search=0xDE3B5425164C4849",
          "identifier"=>"B516CB7A08819697B25E4694DE3B5425164C4849",
          "role"=>"key",
          "service"=>"pgp"},
         {"@type"=>"Account",
          "identifier"=>"larry.salibra",
          "proofType"=>"http",
          "proofUrl"=>
           "https://www.facebook.com/larry.salibra/posts/10100341028448093",
          "service"=>"facebook"}],
      "address"=>{"@type"=>"PostalAddress", "addressLocality"=>"Hong Kong"},
      "description"=>
      "Blockchain, software, security. Decentralize the world (w/ #bitcoin)! 識中文",
      "image"=>
        [{"@type"=>"ImageObject",
          "contentUrl"=>"https://s3.amazonaws.com/kd4/larry",
          "name"=>"avatar"},
         {"@type"=>"ImageObject",
          "contentUrl"=>"https://s3.amazonaws.com/dx3/larry",
          "name"=>"cover"}],
      "name"=>"Larry Salibra",
      "website"=>[{"@type"=>"WebSite", "url"=>"https://www.larrysalibra.com"}]
    }
  end

  let(:fredwilson_legacy_json_profile) do
    {
      "graph"=>{"url"=>"https://s3.amazonaws.com/grph/fredwilson"},
      "website"=>"http://avc.com",
      "location"=>{"formatted"=>"New York City"},
      "avatar"=>{"url"=>"https://s3.amazonaws.com/kd4/fredwilson1"},
      "twitter"=>
      {"username"=>"fredwilson",
       "proof"=>
        {"url"=>"https://twitter.com/fredwilson/status/533040726146162689"}},
      "bio"=>"I am a VC",
      "name"=>{"formatted"=>"Fred Wilson"},
      "cover"=>{"url"=>"https://s3.amazonaws.com/dx3/fredwilson"},
      "v"=>"0.2",
      "bitcoin"=>{"address"=>"1Fbi3WDPEK6FxKppCXReCPFTgr9KhWhNB7"},
      "facebook"=>
      {"username"=>"fred.wilson.963871",
       "proof"=>
        {"url"=>
          "https://facebook.com/fred.wilson.963871/posts/10100401430876108"}}
    }
  end
end
