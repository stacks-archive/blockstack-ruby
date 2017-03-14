require "blockstack/version"
require 'bitcoin'
require 'faraday'

module Blockstack
    USER_AGENT = "blockstack-ruby #{VERSION}"

    def self.get_did_type(decentralized_id)
      did_parts = decentralized_id.split(':')
      raise 'Decentralized IDs must have 3 parts' if did_parts.length != 3
      raise 'Decentralized IDs must start with "did"' if did_parts[0].downcase != 'did'
      did_parts[1].downcase
    end

    def self.get_address_from_did(decentralized_id)
      did_type = get_did_type(decentralized_id)
      return nil if did_type != 'btc-addr'
      decentralized_id.split(':')[2]
    end

    protected

    def self.faraday
      connection = Faraday.new
      connection.headers[:user_agent] = USER_AGENT
      connection
    end
end
