require "openname/version"
require 'net/http'
require 'json'
require 'bitcoin'


##
# A toolkit for the Openname distributed identity & naming system 
module Openname
  DEFAULT_ENDPOINT = "https://www.onename.io" 
  SCHEMA_VERSION = "0.2"
  USERAGENT = "openname-ruby #{VERSION}"
  
  # https://github.com/openname/openname-specifications#usernames
  OPENNAME_REGEX = /^[a-z0-9_]{1,60}$/
  
  @@endpoint = nil

  ##
  # Current endpoint used by the library
  def self.endpoint
    if @@endpoint.nil?
      return DEFAULT_ENDPOINT
    else
      return @@endpoint
    end
  end
  
  ##
  # Set endpoint to +url+
  # if +url+ is +nil+, +DEFAULT_ENDPOINT+ is used as the endpoint
  def self.endpoint=(url)
    @@endpoint = url
  end

  ##
  # Check if the given +openname+ is in proper format
  # Does not downcase input
  def self.valid?(openname)
    Openname::OPENNAME_REGEX.match(openname).nil? ? false : true
  end

  ##
  # Retrieve JSON data stored in Openname record
  def self.get_json(openname) 
    raise ArgumentError.new("#{openname} is not a valid Openname") if !self.valid?(openname)
    uri = URI(self.endpoint + "/#{openname.downcase}.json")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = uri.scheme == "https" ? true : false
    req = Net::HTTP::Get.new(uri.path, {'User-Agent' => USERAGENT})
    res = http.request(req)
    case res.code.to_s
      when "404" then raise NameError.new("User with Openname \"#{openname}\" does not exist")
      when "200" then return JSON.parse(res.body)
	  else
        error = JSON.parse(res.body)
        raise RuntimeError.new("Openname endpoint returned error: #{error["error"]}")
    end  
    
  end
  
  ##
  # Return a +User+ representing the given openname
  def self.get(openname)
    User.from_json(self.get_json(openname),openname)
  end
  
  ##
  # Takes either a bitcoin address or a openname
  # Returns the bitcoin address associated with the openname or passes through address provided
  def self.get_bitcoin_address(openname_or_address)
	 return openname_or_address if Bitcoin.valid_address?(openname_or_address)
	 raise ArgumentError.new("#{openname_or_address} is not a valid Openname or Bitcoin address") if !self.valid?(openname_or_address)
	 user = get(openname_or_address)
	 raise NameError.new("Openname user #{openname_or_address} does not have a Bitcoin address") if !Bitcoin.valid_address?(user.bitcoin_address)
	 return user.bitcoin_address  
  end
  
  class User
    def self.from_json(json,openname)
      User.new(json,openname)
    end
    
    attr_reader :openname
    attr_reader :name_formatted
    attr_reader :avatar_url
    attr_reader :cover_url
    attr_reader :location_formatted
    attr_reader :website
    attr_reader :bio
    attr_reader :github_username
    attr_reader :facebook_username
    attr_reader :twitter_username
    attr_reader :linkedin_username
    attr_reader :bitcoin_address
    attr_reader :bitmessage_address
    attr_reader :bitcoinotc_username
    attr_reader :pgp_fingerprint
    attr_reader :pgp_url
    attr_reader :orgs
    attr_reader :schema_version
    
       
    def initialize(json,openname)
      @openname = openname
      @name_formatted = json["name"]["formatted"] if json["name"]
      @avatar_url = json["avatar"]["url"] if json["avatar"]
      @cover_url = json["cover"]["url"] if json["cover"]
      @location_formatted = json["location"]["formatted"] if json["location"]
      @website = json["website"]
      @bio = json["bio"]
      @github_username = json["github"]["username"] if json["github"]
      @facebook_username = json["facebook"]["username"] if json["facebook"]
      @twitter_username = json["twitter"]["username"] if json["twitter"]
      @linkedin_username = json["linkedin"]["username"] if json["linkedin"]
      @bitcoin_address = json["bitcoin"]["address"] if json["bitcoin"]
      @bitmessage_address = json["bitmessage"]["username"] if json["bitmessage"]
      @bitcoinotc_username = json["bitcoinotc"]["username"] if json["bitcoinotc"]
      @pgp_fingerprint = json["pgp"]["fingerprint"] if json["pgp"]
      @pgp_url = json["pgp"]["url"] if json["url"]
      @schema_version = json["v"]
      @orgs = parse_orgs(json["orgs"])
    end
    
    protected 
    
    def parse_orgs(orgs_json) 
      orgs = Array.new
      if orgs_json
        for org_json in orgs_json
          orgs << Org.new(org_json)    
        end
      end
      orgs
    end
  
  end
  
  class Org
    def self.from_json(json)
      Org.new(json)
    end
    
    attr_reader :url
    attr_reader :relationship
    attr_reader :name
    
    
    def initialize(json)
      @url = json["url"] if json["url"]
      @relationship = json["relationship"] if json["relationship"]
      @name = json["name"] if json["name"]
    end
    
    
  end
  
  protected
  
  def self.check_schema_version(json_result)
    if json_result["v"] != SCHEMA_VERSION
      warn "Openname gem only supports Openname schema version #{SCHEMA_VERSION}"
    end
  end

end