require "blockstack/version"
require 'bitcoin'
require 'faraday'

module Blockstack
    USER_AGENT = "blockstack-ruby #{VERSION}"

    def self.test
      faraday.get "http://localhost:6270/v1/names/larry.id"
    end

    private

    def self.faraday
      connection = Faraday.new
      connection.headers[:user_agent] = USER_AGENT
      connection
    end
end
