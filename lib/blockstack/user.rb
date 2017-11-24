module Blockstack
  class User
    def self.from_json(json, username)
      User.new(json, username)
    end

    attr_reader :username
    attr_reader :name_formatted
    attr_reader :avatar_url
    attr_reader :cover_url
    attr_reader :location_formatted
    attr_reader :website
    attr_reader :bio
    attr_reader :angellist_username
    attr_reader :github_username
    attr_reader :facebook_username
    attr_reader :twitter_username
    attr_reader :instagram_username
    attr_reader :linkedin_url
    attr_reader :bitcoin_address
    attr_reader :bitmessage_address
    attr_reader :bitcoinotc_username
    attr_reader :pgp_fingerprint
    attr_reader :pgp_url
    attr_reader :orgs
    attr_reader :schema_version

    def initialize(json, username)
      if(json['profile'])
        json = json['profile']
      end
      if(json['v'] == '0.2')
        @username = username
        @name_formatted = json['name']['formatted'] if json['name']
        @avatar_url = json['avatar']['url'] if json['avatar']
        @cover_url = json['cover']['url'] if json['cover']
        @location_formatted = json['location']['formatted'] if json['location']
        @website = json['website']
        @bio = json['bio']
        @angellist_username = json['angellist']['username'] if json['angellist']
        @github_username = json['github']['username'] if json['github']
        @facebook_username = json['facebook']['username'] if json['facebook']
        @twitter_username = json['twitter']['username'] if json['twitter']
        @instagram_username = json['instagram']['username'] if json['instagram']
        @linkedin_url = json['linkedin']['url'] if json['linkedin']
        @bitcoin_address = json['bitcoin']['address'] if json['bitcoin']
        @bitmessage_address = json['bitmessage']['address'] if json['bitmessage']
        @bitcoinotc_username = json['bitcoinotc']['username'] if json['bitcoinotc']
        @pgp_fingerprint = json['pgp']['fingerprint'] if json['pgp']
        @pgp_url = json['pgp']['url'] if json['pgp']
        @schema_version = json['v']
        @orgs = parse_orgs(json['orgs'])
      else
        @username = username
        @name_formatted = json['name'] if json['name']
        @avatar_url = find_image_url(json, 'avatar')
        @cover_url = find_image_url(json, 'cover')
        @location_formatted = json['address']['addressLocality'] if json['address']
        @website = json['website'][0]['url'] if json['website'] && json['website'][0]
        @bio = json['description']
        @angellist_username = find_account_username(json, 'angellist')
        @github_username = find_account_username(json, 'github')
        @facebook_username = find_account_username(json, 'facebook')
        @twitter_username = find_account_username(json, 'twitter')
        @instagram_username = find_account_username(json, 'instagram')
        @linkedin_url = find_account_username(json, 'linkedin')
        @bitcoin_address = find_account_username(json, 'bitcoin')
        @bitmessage_address = find_account_username(json, 'bitmessage')
        @bitcoinotc_username = find_account_username(json, 'bitcoinotc')
        @pgp_fingerprint = find_account_username(json, 'pgp')
        @pgp_url = find_account(json, 'pgp')['contentUrl'] if @pgp_fingerprint
        @schema_version = '0.3'
        @orgs = parse_orgs(json['orgs'])
      end
    end

    def openname
      warn '[DEPRECATION] `openname` is deprecated.  Please use `username` instead.'
      username
    end

    protected

    def find_image_url(json, type)
      images = json['image']
      if(images && images.kind_of?(Array))
        for image in images
          return image['contentUrl'] if image['name'] == type
        end
      end
      nil
    end

    def find_account(json, service)
      accounts = json['account']
      if(accounts && accounts.kind_of?(Array))
        for account in accounts
          return account if account['service'] == service
        end
      end
      nil
    end

    def find_account_username(json, service)
      account = find_account(json, service)
      if(account)
        return account['identifier']
      end
      nil
    end

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
end
